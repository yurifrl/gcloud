# Base google image
FROM google/cloud-sdk

ENV DOCKER_VERSION 1.9.1 DOCKER_MACHINE_VERSION 0.7.0

# Download docker
ADD http://get.docker.com/builds/Linux/x86_64/docker-1.9.1.tgz ./docker.tgz

# Download docker machine
ADD http://github.com/docker/machine/releases/download/v0.7.0/docker-machine-Linux-x86_64 /bin/docker-machine

# Untar docker
RUN tar -zxvf docker.tgz usr/local/bin/docker -O > /bin/docker

# Give docker the execution permision
RUN chmod +x /bin/docker

# Give docker machine the execution permision
RUN chmod +x /bin/docker-machine

# cleanup
RUN rm docker.tgz

# Add some volumes
VOLUME [".kube", ".kubecfg"]
