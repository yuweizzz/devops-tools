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
