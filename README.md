# devops-tools

## application

* [gitea](https://github.com/yuweizzz/devops-tools/tree/master/gitea)
* [mysql](https://github.com/yuweizzz/devops-tools/tree/master/mysql)
* [openldap](https://github.com/yuweizzz/devops-tools/tree/master/openldap)
* [redis](https://github.com/yuweizzz/devops-tools/tree/master/redis)
* [registry](https://github.com/yuweizzz/devops-tools/tree/master/registry)
* [victoria-metrics](https://github.com/yuweizzz/devops-tools/tree/master/victoria-metrics)

## tekton

### TaskRun: git-clone

``` bash
# Task
kubectl apply -f tekton/resources/task/git-clone.yaml

# PersistentVolumeClaim
kubectl apply -f tekton/resources/taskrun/git-clone-run/pvc.yaml

# Secret
ssh-keygen -t rsa -C "Git Clone Key" -P "" -f tekton/resources/taskrun/git-clone-run/id_rsa
cp tekton/resources/task/git-clone/config tekton/resources/taskrun/git-clone-run/config
kubectl create secret generic ssh-credentials \
  --from-file=id_rsa=tekton/resources/taskrun/git-clone-run/id_rsa \
  --from-file=config=tekton/resources/taskrun/git-clone-run/config

# TaskRun
kubectl create -f tekton/resources/taskrun/git-clone-run/taskrun.yaml
```

### TaskRun: kaniko

``` bash
# Create docker registry
kubectl create namespace devops
kubectl kustomize registry/base | kubectl apply -f -

# Task
kubectl apply -f tekton/resources/task/kaniko.yaml

# Use persistentVolumeClaim from git-clone-run

# TaskRun
kubectl create -f tekton/taskrun/kaniko-run/taskrun.yaml
```
