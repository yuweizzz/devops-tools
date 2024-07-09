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
