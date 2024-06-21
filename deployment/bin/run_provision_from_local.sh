#!/usr/bin/env bash

set -ex

REMOTE_USER=$1
SERVER_IP=$2

if [ -z $SERVER_IP ]; then
    echo "Server IP not provided."
    exit 1
fi

PUBLIC_SSH_KEY=$(cat $HOME/.ssh/id_ed25519.pub)

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 ./provision_server.sh $REMOTE_USER@$SERVER_IP:./provision_server.sh
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 $REMOTE_USER@$SERVER_IP "chmod +x ./provision_server.sh && ./provision_server.sh \"$PUBLIC_SSH_KEY\""
