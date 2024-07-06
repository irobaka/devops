#!/usr/bin/env bash

set -ex

REMOTE_USER=$1
SERVER_IP=$2
DOCKERHUB_USERNAME=$3
DOCKERHUB_TOKEN=$4


if [ -z $SERVER_IP ]; then
    echo "Server IP not provided."
    exit 1
fi

PUBLIC_SSH_KEY=$(cat $HOME/.ssh/id_ed25519.pub)

echo DOC

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 ./provision_manager.sh $REMOTE_USER@$SERVER_IP:./provision_manager.sh
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 $REMOTE_USER@$SERVER_IP "chmod +x ./provision_manager.sh && ./provision_manager.sh \"$PUBLIC_SSH_KEY\"" "$DOCKERHUB_USERNAME" "$DOCKERHUB_TOKEN" "$SERVER_IP"
