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
