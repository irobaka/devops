#!/usr/bin/env bash

set -e

REMOTE_USER=$1
SERVER_IP=$2
IMAGE_TAG=$3

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 ./rollback.sh $REMOTE_USER@SERVER_IP:./rollback.sh
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 $REMOTE_USER@$SERVER_IP "chmod +x ./rollback.sh && ./rollback.sh $BACKUP_FILENAME"
