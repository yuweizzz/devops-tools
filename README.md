# devops-tools

## gitea

``` bash
# create kustomization default namespace
kubectl create namespace devops

# apply
kubectl kustomize gitea/base | kubectl apply -f -

# delete
kubectl kustomize gitea/base | kubectl delete -f -

# modify
kubectl kustomize gitea/base | kubectl apply -f - --prune -l app="gitea"
```

## mysql

``` bash
# create kustomization default namespace
kubectl create namespace databases

# apply
kubectl kustomize mysql/base | kubectl apply -f -

# delete
kubectl kustomize mysql/base | kubectl delete -f -

# modify
kubectl kustomize mysql/base | kubectl apply -f - --prune -l app="mysql"
```

## openldap

``` bash
# create kustomization default namespace
kubectl create namespace databases

# apply
kubectl kustomize openldap/base | kubectl apply -f -

# delete
kubectl kustomize openldap/base | kubectl delete -f -

# modify
kubectl kustomize openldap/base | kubectl apply -f - --prune -l app="openldap"
```

## redis

``` bash
# create kustomization default namespace
kubectl create namespace databases

# apply
kubectl kustomize redis/base | kubectl apply -f -

# delete
kubectl kustomize redis/base | kubectl delete -f -

# modify
kubectl kustomize redis/base | kubectl apply -f - --prune -l app="redis"
```

## registry

``` bash
# create kustomization default namespace
kubectl create namespace devops

# apply
kubectl kustomize registry/base | kubectl apply -f -
kubectl kustomize registry/overlays/security | kubectl apply -f -

# delete
kubectl kustomize registry/base | kubectl delete -f -
kubectl kustomize registry/overlays/security | kubectl delete -f -

# modify
kubectl kustomize registry/base | kubectl apply -f - --prune -l app="registry"
kubectl kustomize registry/overlays/security | kubectl apply -f - --prune -l app="registry"
```

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
kubectl apply -f tekton/task/kaniko.yaml

# PersistentVolumeClaim from git-clone-run
# kubectl apply -f tekton/taskrun/kaniko-run/pvc.yaml

# TaskRun
kubectl create -f tekton/taskrun/kaniko-run/taskrun.yaml
```

## victoria-metrics

``` bash
# create kustomization default namespace
kubectl create namespace databases

# apply
kubectl kustomize victoria-metrics/base | kubectl apply -f -

# delete
kubectl kustomize victoria-metrics/base | kubectl delete -f -

# modify
kubectl kustomize victoria-metrics/base | kubectl apply -f - --prune -l app="victoria-metrics"
```
