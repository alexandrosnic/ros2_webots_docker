FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG user_id=1000

# Update apt cache
RUN apt-get update

# System locale
RUN echo 'Europe/Belgrade' > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime && \
    apt-get install -y --no-install-recommends tzdata locales && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    printf 'XKBMODEL="pc105"\nXKBLAYOUT="us"\nXKBVARIANT="intl"\nXKBOPTIONS=""\n' > /etc/default/keyboard

# General dependencies
RUN apt-get -y install apt-utils gnupg2 lsb-release sudo rsync python3 python3-pip \
               git git-lfs wget curl vim pciutils keyboard-configuration

COPY ./config/ps1.sh /tmp

# User setup
RUN useradd -d /ccbts -m \
            -u $user_id -U \
            -s /usr/bin/bash \
            -c "COCOBOTS" ccbts && \
    echo 'ccbts ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cat /tmp/ps1.sh | tee -a /ccbts/.bashrc /root/.bashrc && \
    echo 'source /ccbts/.setup/config/shortcuts.sh' | tee -a /ccbts/.bashrc

# Copy first-time setup script and user configuration
RUN mkdir -p /ccbts/.setup
COPY ./entrypoint.sh /ccbts/.setup/
RUN chmod +x /ccbts/.setup/entrypoint.sh
COPY ./config /ccbts/.setup/config
COPY ./Makefile /ccbts/.setup/
COPY ./provision /ccbts/.setup/provision
COPY ./install_dependencies.sh /ccbts/.setup/
RUN chmod +x /ccbts/.setup/install_dependencies.sh
RUN chown -R $user_id:$user_id /ccbts/.setup

# Login setup
USER ccbts
WORKDIR /ccbts

# Container startup
CMD ["/ccbts/.setup/entrypoint.sh"]
