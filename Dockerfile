FROM gcr.io/google_appengine/base

# Prepare the image.
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y -qq --no-install-recommends wget unzip python php5-mysql php5-cli php5-cgi openjdk-7-jre-headless openssh-client python-openssl && apt-get clean

# Install the Google Cloud SDK.
ENV HOME /
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1

ADD https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-133.0.0-linux-x86_64.tar.gz /tmp/gcloud.tar.gz
RUN tar -xzvf /tmp/gcloud.tar.gz -C /
RUN /google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app-engine-java app-engine-python app kubectl alpha beta gcd-emulator pubsub-emulator cloud-datastore-emulator app-engine-go bigtable

# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN /google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Disable updater completely.
# Running `gcloud components update` doesn't really do anything in a union FS.
# Changes are lost on a subsequent run.
RUN sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json

RUN mkdir /.ssh

ENV PATH /google-cloud-sdk/bin:$PATH

# Base google image
FROM google/cloud-sdk:latest

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
VOLUME ["/.config", "/.kube", "/.kubecfg"]

# CMD
CMD ["/bin/bash"]
