# Base google image
FROM google/cloud-sdk

# Download docker
ADD http://get.docker.com/builds/Linux/x86_64/docker-1.12.3.tgz /tmp/docker.tgz

# Download docker machine
ADD http://github.com/docker/machine/releases/download/v0.8.2/docker-machine-Linux-x86_64 /bin/docker-machine

# Untar docker
RUN tar --strip-components=1 -xvzf /tmp/docker.tgz -C /usr/local/bin

# Give docker the execution permision
RUN chmod +x /usr/local/bin/docker

# Give docker machine the execution permision
RUN chmod +x /bin/docker-machine

# cleanup
RUN rm /tmp/docker.tgz

# Add some volumes
VOLUME [".kube", ".kubecfg", "/.config"]

# CMD
CMD ["/bin/bash"]
