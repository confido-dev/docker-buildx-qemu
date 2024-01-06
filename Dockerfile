FROM ubuntu:mantic as base

ENV DEBIAN_FRONTEND=noninteractive

ARG BUILDX_VERSION
ENV BUILDX_VERSION ${BUILDX_VERSION}

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg wget curl jq && \
    echo 'deb http://archive.ubuntu.com/ubuntu/ mantic main restricted universe multiverse' > /etc/apt/sources.list && \
    echo 'deb http://archive.ubuntu.com/ubuntu/ mantic-updates main restricted universe multiverse' >> /etc/apt/sources.list && \
    echo 'deb http://archive.ubuntu.com/ubuntu/ mantic-backports main restricted universe multiverse' >> /etc/apt/sources.list && \
    echo 'deb http://security.ubuntu.com/ubuntu mantic-security main restricted universe multiverse' >> /etc/apt/sources.list && \
    echo 'deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/docker.gpg] https://download.docker.com/linux/ubuntu mantic stable' >> /etc/apt/sources.list && \
    curl -s 'https://download.docker.com/linux/ubuntu/gpg' | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/docker.gpg --import && \
    chmod 644 /etc/apt/trusted.gpg.d/* && \
    apt-get update && \
    apt-get install -y --no-install-recommends qemu-user-static binfmt-support docker-ce-cli && \
    apt-get remove -y --purge apt-transport-https gnupg && \
    apt-get autoremove -y --purge && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/log/* /var/tmp/* /tmp/*

RUN mkdir -p /usr/libexec/docker/cli-plugins && \
    curl -s -L "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-arm64" \
       -o /usr/libexec/docker/cli-plugins/docker-buildx && chmod a+x /usr/libexec/docker/cli-plugins/docker-buildx \
