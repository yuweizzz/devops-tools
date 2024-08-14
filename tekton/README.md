## Tekton

### Install

安装 tekton 可以参考 `install/install.sh` 脚本文件。

所有运行的相关资源都存放在命名空间 `tekton-worker` 中。

``` bash
kubectl create namespace tekton-worker
```

### Task

目前定义了以下几个 Task ：

* `resources/task/git-clone.yaml` 用于克隆代码。
* `resources/task/kaniko.yaml` 用于构建镜像。
* `resources/task/maven.yaml` 用于打包 java 项目。
* `resources/task/npm.yaml` 用于打包 javascript 项目。
* `resources/task/ssh-client.yaml` 用于上传文件。

因为有些构建是共享同一个依赖数据卷，所以为了限制短时间内单个 PipelineRun 的多次触发，引入了基于 Lease 的自定义资源，定义内容存放在 `resources/crd/lease.yaml` 之中，涉及的 Task 资源如下：

* `resources/task/acquire-lease.yaml` 是获取租约的 task ，作为 PipelineRun 运行时的第一个任务。
* `resources/task/release-lease.yaml` 是释放租约的 task ，作为 PipelineRun 运行时的最后一个任务。

``` bash
# 所有 task 默认添加到 tekton-worker 命名空间中

# Apply tasks
kubectl apply -f resources/task/kaniko.yaml
kubectl apply -f resources/task/npm.yaml


# git-clone task
# Create a new ssh key and upload to github/gitlab
# Or use a exist ssh key
ssh-keygen -t rsa -C "clone@email.com" -P "" -f resources/static/clone_id_rsa
# Create secret
kubectl create secret generic clone-ssh-credentials -n tekton-worker \
  --from-file=id_rsa=resources/static/clone_id_rsa \
  --from-file=config=resources/static/config
kubectl apply -f resources/task/git-clone.yaml


# ssh-client task
ssh-keygen -t rsa -C "upload@email.com" -P "" -f resources/static/upload_id_rsa
# Create secret
kubectl create secret generic upload-ssh-credentials -n tekton-worker \
  --from-file=id_rsa=resources/static/upload_id_rsa
kubectl apply -f resources/task/ssh-client.yaml


# maven task
kubectl create configmap maven-settings -n tekton-worker \
  --from-file=settings.xml=resources/static/settings.xml
kubectl apply -f resources/task/maven.yaml


# lease CRD and task
kubectl apply -f resources/crd/lease.yaml
kubectl apply -f resources/task/acquire-lease.yaml
kubectl apply -f resources/task/release-lease.yaml
```

### TaskRun

TaskRun 可以直接运行 tekton Task ，这里提供了一个 TaskRun 作为参考。

* git-clone

``` bash
# Secret clone-ssh-credentials 已经在添加 task 时创建

# Replace clone endpoint
yq -i 'select(documentIndex == 1) | .spec.params[0].value = "git@github.com:mike/diaspora.git"' \
  resources/taskrun/git-clone-bundle.yaml

# Create taskrun
kubectl create -f resources/taskrun/git-clone-bundle.yaml
```

### Pipeline

目前定义了以下三个 Pipeline ：

* `resources/pipeline/java-pipeline.yaml`
* `resources/pipeline/javascript-pipeline.yaml`
* `resources/pipeline/kaniko-pipeline.yaml`

``` bash
# apply all pipeline
kubectl apply -f resources/pipeline/java-pipeline.yaml
kubectl apply -f resources/pipeline/javascript-pipeline.yaml
kubectl apply -f resources/pipeline/kaniko-pipeline.yaml
```

#### java-pipeline

java-pipeline 使用了以下参数：

* `git-url`: 代码拉取地址，比如 `git@example.com:mike/diaspora.git` 。
* `code-subdir`: 指定工作目录，一般用来指定到具体的代码子目录，也可以用 `.` 在根目录构建。
* `git-revision`: git revision 。
* `build-cmd`: maven 打包命令，一般是 `clean package` ，不过这个实际上是列表变量，即 `["clean", "package"]` 。
* `maven-repo`: maven 依赖所在的数据卷，需要提前创建。
* `lease-label`: 用来命名自定义的 lease 资源。
* `target-dir`: 构建文件的输出目录。
* `deploy-host`: 需要上传构建文件的主机，这是列表变量，可以指定多个主机。
* `deploy-dst-dir`: 上传到目标主机的对应目录。

workspaces 共享克隆密钥和上传密钥，源代码的 workspaces 是各自独立的。

实际的 pipeline 过程是 acquire-lease -> clone -> build -> upload/release-lease 。其中 upload 和 release-lease 在 build 成功后会并行执行。但如果这个过程失败导致 lease 没有正常释放，可能要手动删除 lease 后才能重新运行。

项目构建时， maven 实际上会在源代码目录下的 `$(params.code-subdir)` 中运行构建命令，并且会将依赖存储在 maven-repo 的数据卷中。

在上传过程中，会将 `$(params.code-subdir)/$(params.target-dir)` 内的文件全量上传到目标机器的 `$(params.deploy-dst-dir)` 目录。

#### javascript-pipeline

javascript-pipeline 使用了以下参数：

* `git-url`: 代码拉取地址，比如 `git@example.com:mike/diaspora.git` 。
* `code-subdir`: 指定工作目录，一般用来指定到具体的代码子目录，也可以用 `.` 在根目录构建。
* `git-revision`: git revision 。
* `build-cmd`: npm 构建命令，一般是 `npm run build` ，这个变量不同于 java-pipeline 中的 `build-cmd` ，并不是列表变量。
* `deps-volume`: node_modules 依赖目录所在的数据卷，需要提前创建。
* `lease-label`: 用来命名自定义的 lease 资源。
* `dist-dir`: 构建文件的输出目录，默认值是 "dist" 。
* `deploy-host`: 需要上传构建文件的主机，这是列表变量，可以指定多个主机。
* `deploy-dst-dir`: 上传到目标主机的对应目录。

workspaces 部分和 java-pipeline 一致。

整个 pipeline 和 java-pipeline 工作过程类似，但是 npm 的依赖部分每次运行时都会从数据卷中 mv 到 Pod 中，在第一次构建后，可以节省后续构建的下载时间，等待构建完成后会重新将依赖写回数据卷，这个过程可能可以进一步优化。

#### kaniko-pipeline

TODO

### PipelineRun

提供了各自对应的 PipelineRun 文件：

* `resources/pipelinerun/java-pipelinerun.yaml` 对应 `resources/pipeline/java-pipeline.yaml` 。
* `resources/pipelinerun/javascript-pipelinerun.yaml` 对应 `resources/pipeline/javascript-pipeline.yaml` 。

``` bash
# 修改对应的参数后直接运行即可
kubectl create -f resources/pipelinerun/java-pipelinerun.yaml
kubectl create -f resources/pipelinerun/javascript-pipelinerun.yaml
```

### Trigger

`resources/trigger/event.json` 是 gitlab push event 的请求 body 示例，根据 gitlab 官方文档的 [Payload example](https://docs.gitlab.com/ee/user/project/integrations/webhook_events.html#push-events) 修改而来。
