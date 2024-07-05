#!/usr/bin/env bash

# install tekton pipeline
curl https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml -o pipeline.yaml
kubectl apply -f pipeline.yaml

# install tekton dashboard
curl https://storage.googleapis.com/tekton-releases/dashboard/latest/release-full.yaml -o dashboard.yaml
kubectl apply -f dashboard.yaml

# install tekton triggers
curl https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml -o triggers.yaml
curl https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml -o interceptors.yaml
kubectl apply -f triggers.yaml
kubectl apply -f interceptors.yaml
