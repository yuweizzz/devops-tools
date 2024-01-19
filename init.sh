#!/usr/bin/env bash

kubectl create namespace devops

kubectl kustomize registry/base | kubectl apply -f -

# delete
# kubectl kustomize registry/base | kubectl delete -f -

# modify
# kubectl kustomize registry/base | kubectl apply -f - --prune -l app="registry"

kubectl kustomize gitea/base | kubectl apply -f -

# delete
# kubectl kustomize gitea/base | kubectl delete -f -

# modify
# kubectl kustomize gitea/base | kubectl apply -f - --prune -l app="gitea"

# tekton
# curl -s https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml > tekton/tekton-release.yaml
# kubectl apply -f tekton/tekton-release.yaml

# tekton git-clone task
# kubectl apply -f tekton/git-clone/git-clone-task.yaml
# kubectl apply -f tekton/git-clone/source-pvc.yaml
# ssh-keygen -t rsa -C "Gitea Deploy Key" -P "" -f ./tekton/git-clone/id_rsa
# kubectl create secret generic deploy-ssh-credentials --from-file=id_rsa=./tekton/git-clone/id_rsa --from-file=config=./tekton/git-clone/config
# kubectl create -f tekton/git-clone-taskrun.yaml
