## Applications

### gitea

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

### mysql

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

### openldap

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

### redis

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

### registry

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

### victoria-metrics

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
