#!/usr/bin/env bash

set -e

PUBLIC_SSH_KEY=$1
DOCKERHUB_USERNAME=$2
DOCKERHUB_TOKEN=$3
SERVER_IP=$4

sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

if id -u "devops" >/dev/null 2>&1; then
    echo 'user exists'
else
    useradd -G www-data,root,sudo,docker -u 1000 -d /home/devops devops
    mkdir -p /home/devops/.ssh
    touch /home/devops/.ssh/authorized_keys
    chown -R devops:devops /home/devops
    chown -R devops:devops /usr/src
    chmod 700 /home/devops/.ssh
    chmod 644 /home/devops/.ssh/authorized_keys

    if [ -n "$PUBLIC_SSH_KEY" ]; then
      echo "$PUBLIC_SSH_KEY" >> /home/devops/.ssh/authorized_keys
    fi

    echo "devops ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/devops

    echo 'user added'
fi

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

docker login -u "$DOCKERHUB_USERNAME" -p "$DOCKERHUB_TOKEN"

ufw allow 2377 && ufw allow 7946 && ufw allow 4789

docker swarm init --advertise-addr "$SERVER_IP"



