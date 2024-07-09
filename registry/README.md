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
