#!/usr/bin/env bash

set -e

REMOTE_USER=$1
SERVER_IP=$2
BACKUP_FILENAME=$3
POSTGRES_PASSWORD=$4

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 ./restore.sh $REMOTE_USER@$SERVER_IP:./restore.sh
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 $REMOTE_USER@$SERVER_IP "chmod +x ./restore.sh && ./restore.sh $BACKUP_FILENAME $POSTGRES_PASSWORD"
