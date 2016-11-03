#!/bin/sh

# docker run --rm -ti -w /current \
#   -v /var/run/docker.sock:/var/run/docker.sock \
#   -v $HOME/.docker:/.docker \
#   -v $HOME/.config:/.config \
#   -v $HOME/.kube:/.kube \
#   -v $HOME/.kubecfg:/.kubecfg \
#   -v $(pwd):/current \
#   --volumes-from gcloud-config yurifl/gcloud $@

docker run --rm -ti -w /current \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.ssh:/.ssh \
  -v $(pwd):/current \
  --volumes-from gcloud-config yurifl/gcloud $@

