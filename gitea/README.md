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
