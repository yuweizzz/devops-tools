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
