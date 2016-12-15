FROM alpine

RUN apk update
RUN apk upgrade
RUN apk --update add unzip python php5-common php5 php5-mysql php5-cli php5-cgi openssh-client openssl ca-certificates bash

# http://get.docker.com/builds/Linux/x86_64/docker-1.12.3.tgz
ENV COMPACT_DOCKER ./vendor/docker-1.12.3.tgz
# http://github.com/docker/machine/releases/download/v0.8.2/docker-machine-Linux-x86_64
ENV COMPACT_DOCKER_MACHINE ./vendor/docker-machine-Linux-x86_64
# https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip
ENV COMPACT_GOOGLE_CLOUD ./vendor/google-cloud-sdk.zip
# https://github.com/kubernetes-incubator/kompose
ENV COMPACT_KOMPOSE ./vendor/kompose_linux-amd64.tar.gz
# http://readme.drone.io/0.5/install/cli/
ENV COMPACT_DRONE ./vendor/drone-0.5.0

# ============================================================================
ENV HOME /
WORKDIR $HOME
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
# Install the Google Cloud SDK.
ADD $COMPACT_GOOGLE_CLOUD /tmp/google-cloud-sdk.zip
RUN unzip /tmp/google-cloud-sdk.zip -d / && rm /tmp/google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.zshrc --additional-components app-engine-python app kubectl alpha beta gcd-emulator pubsub-emulator cloud-datastore-emulator app-engine-go bigtable

# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of
# gcloud.
RUN google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Disable updater completely.
# Running `gcloud components update` doesn't really do anything in a union FS.
# Changes are lost on a subsequent run.
RUN sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json

ENV PATH /google-cloud-sdk/bin:$PATH

# ============================================================================
# Download docker
ADD $COMPACT_DOCKER /tmp/docker
RUN cp /tmp/docker/docker/docker /usr/local/bin
RUN rm -rf /tmp/docker

# Download docker machine
ADD $COMPACT_DOCKER_MACHINE /bin/docker-machine
RUN chmod +x /bin/docker-machine

# ============================================================================
COPY $COMPACT_DRONE /usr/local/bin

# Clean up
RUN apk del unzip
RUN apk --update add curl vim go git gcc linux-headers wget

ADD $COMPACT_KOMPOSE /tmp
RUN mv /tmp/kompose_linux-amd64/kompose /usr/local/bin/kompose
RUN chmod +x /usr/local/bin/kompose

CMD ["/bin/sh"]
