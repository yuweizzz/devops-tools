# devops-tools

## tekton

### TaskRun: git-clone

``` bash
# Task
kubectl apply -f tekton/task/git-clone.yaml

# PersistentVolumeClaim
kubectl apply -f tekton/taskrun/git-clone-run/pvc.yaml

# Secret
ssh-keygen -t rsa -C "Git Clone Key" -P "" -f tekton/taskrun/git-clone-run/id_rsa
kubectl create secret generic ssh-credentials --from-file=id_rsa=tekton/taskrun/git-clone-run/id_rsa --from-file=config=tekton/taskrun/git-clone-run/config

# TaskRun
kubectl create -f tekton/taskrun/git-clone-run/taskrun.yaml
```
