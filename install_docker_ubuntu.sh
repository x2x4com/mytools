#!/bin/bash



sudo apt-get -y remove docker docker-engine docker.io ; \
sudo apt-get update && \
sudo apt-get -y install \
    python3-pip python3-dev \
    libffi-dev openssl-dev gcc libc-dev \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
# sudo apt-key fingerprint 0EBFCD88
# pub   4096R/0EBFCD88 2017-02-22
#      Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
# uid                  Docker Release (CE deb) <docker@docker.com>
# sub   4096R/F273FCD8 2017-02-22
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" && \
sudo apt-get update && \
sudo apt-get -y install docker-ce && \
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
sudo chmod +x /usr/local/bin/docker-compose && \
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose && \
sudo usermod -a -G docker $(whoami) && \
docker version && \
echo "Docker Compose Version:" && docker-compose --version


