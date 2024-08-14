## Tekton

### Install

安装 tekton 可以参考 `install/install.sh` 脚本文件。

所有运行的相关资源都存放在命名空间 `tekton-worker` 中。

``` bash
kubectl create namespace tekton-worker
```

### TaskRun

TaskRun 可以直接运行单个 tekton Task ，这里提供了一个 TaskRun 作为参考。

* git-clone

``` bash
# Apply task
kubectl apply -f resources/task/git-clone.yaml

# Create a new ssh key and upload to github/gitlab
# Or use a exist ssh key
ssh-keygen -t rsa -C "hi@email.com" -P "" -f resources/static/id_rsa

# Create secret
kubectl create secret generic clone-ssh-credentials -n tekton-worker \
  --from-file=id_rsa=resources/static/id_rsa \
  --from-file=config=resources/static/config

# Replace clone endpoint
yq -i 'select(documentIndex == 1) | .spec.params[0].value = "git@github.com:mike/diaspora.git"' resources/taskrun/git-clone-bundle.yaml

# Create taskrun
kubectl create -f resources/taskrun/git-clone-bundle.yaml
```
