#!/usr/bin/env bash

kubectl create namespace devops

kubectl kustomize registry/base | kubectl apply -f -

# delete
# kubectl kustomize registry/base | kubectl delete -f -

# modify
# kubectl kustomize registry/base | kubectl apply -f - --prune -l app="registry"
