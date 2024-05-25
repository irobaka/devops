#!/usr/bin/env bash

set -e

SSH_USER=$1
SERVER_IP=$2
BACKUP_FILENAME=$3

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops $HOME/.ssh/id_devops $SSH_USER@SERVER_IP:~/.ssh/id_devops
scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops ./restore.sh $SSH_USER@SERVER_IP:./restore.sh
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_devops $SSH_USER@$SERVER_IP "chmod +x ./restore.sh && ./restore.sh $BACKUP_FILENAME"
