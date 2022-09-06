# Basic development environment Docker image
FROM debian:buster 

ARG USER=me
ARG UID=501

ENV HOME=/home/me
ENV GOLANG_VERSION=1.18

# Install Docker 
# Source: https://docs.docker.com/engine/install/debian/
RUN \
  apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release &&\
  mkdir -p /etc/apt/keyrings &&\
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&\
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null &&\
  apt-get update && apt-get install -y \
    docker-ce-cli \
    docker-compose-plugin

# Install Golang 
# Source: https://go.dev/doc/install
RUN \
  curl -LO https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz &&\
  tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz 

# Install other tools 
RUN \
  apt-get install -y \
    sudo \
    file \
    direnv \
    ssh \
    tmux \
    vim \
    git

# Create a user account
RUN \
  useradd --home-dir /user/${USER} --shell /bin/bash --uid ${UID} ${USER} &&\
  usermod -aG sudo ${USER} &&\
  echo "${USER}  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${USER}

VOLUME /home/${USER}
WORKDIR /home/${USER}
USER 501
ENTRYPOINT tmux

# docker build -t calebhailey/workstation:latest .
# docker build --build-arg USER=${USER} --build-arg UID=${UID} -t calebhailey/workstation:latest .
# docker run --rm --name workstation -v ${HOME}:/home/me -it calebhailey/workstation:latest
