# Bse image
FROM gcr.io/google_appengine/base

# Envs
ENV DOCKER_VERSION 1.9.1
ENV DOCKER_MACHINE_VERSION 0.7.0
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1

# Prepare the image.
RUN apt-get update && apt-get install -y -qq --no-install-recommends wget unzip python php5-mysql php5-cli php5-cgi openjdk-7-jre-headless openssh-client python-openssl && apt-get clean

# Install the Google Cloud SDK.
RUN mkdir /.ssh
ENV PATH /google-cloud-sdk/bin:$PATH

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

# Install Gcloud CLI
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app-engine-java app-engine-python app kubectl alpha beta gcd-emulator pubsub-emulator

# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Disable updater completely.
# Running `gcloud components update` doesn't really do anything in a union FS.
# Changes are lost on a subsequent run.
RUN sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json

# Add some volumes
VOLUME [".kube", ".kubecfg", ".config"]

#
CMD ["/bin/bash"]
