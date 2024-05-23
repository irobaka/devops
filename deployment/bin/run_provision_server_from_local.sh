#!/usr/bin/env bash

set -ex

SSH_USER=$1
SERVER_IP=$2
POSTGRES_PASSWORD=$3

PUBLIC_SSH_KEY=$(cat $HOME/.ssh/id_devops.pub)

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops $HOME/.ssh/id_devops $SSH_USER@$SERVER_IP:~/.ssh/id_devops
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops $SSH_USER@$SERVER_IP "ssh-keyscan github.com >> ~/.ssh/known_hosts"
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops $SSH_USER@$SERVER_IP "sort ~/.ssh/known_hosts | uniq > ~/.ssh/known_hosts.uniq"
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops $SSH_USER@$SERVER_IP "mv ~/.ssh/known_hosts{.uniq,}"
scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops ./provision_server.sh $SSH_USER@$SERVER_IP:./provision_server.sh
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops $SSH_USER@$SERVER_IP "chmod +x ./provision_server.sh && ./provision_server.sh $POSTGRES_PASSWORD \"$PUBLIC_SSH_KEY\""
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops $SSH_USER@$SERVER_IP "ssh-keyscan github.com >> /home/devops/.ssh/known_hosts"
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops $SSH_USER@$SERVER_IP "sort /home/devops/.ssh/known_hosts | uniq > /home/devops/.ssh/known_hosts.uniq"
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops $SSH_USER@$SERVER_IP "mv /home/devops/.ssh/known_hosts{.uniq,}"
