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

因为有些构建依赖是共享同一个数据卷，所以为了限制短时间内单个 PipelineRun 的多次触发，引入了基于 Lease 的自定义资源，定义内容存放在 `resources/crd/lease.yaml` 之中，涉及的 Task 资源如下：

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

### PipelineRun

目前定义了以下三个 Pipeline ：

* `resources/pipeline/java-pipeline.yaml`
* `resources/pipeline/javascript-pipeline.yaml`
* `resources/pipeline/kaniko-pipeline.yaml`

#### java-pipeline

TODO

#### javascript-pipeline

TODO

#### kaniko-pipeline

TODO
