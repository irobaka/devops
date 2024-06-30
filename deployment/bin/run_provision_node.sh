#!/usr/bin/env bash

set -ex

REMOTE_USER=$1
SERVER_IP=$2
DOCKERHUB_USERNAME=$3
DOCKERHUB_TOKEN=$4
SWARM_WORKER_TOKEN=$5
SWARM_MANAGER_IP_PORT=$6


if [ -z $SERVER_IP ]; then
    echo "Server IP not provided."
    exit 1
fi

PUBLIC_SSH_KEY=$(cat $HOME/.ssh/id_ed25519.pub)

echo DOC

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 ./provision_node.sh $REMOTE_USER@$SERVER_IP:./provision_node.sh
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 $REMOTE_USER@$SERVER_IP "chmod +x ./provision_node.sh && ./provision_node.sh \"$PUBLIC_SSH_KEY\"" "$DOCKERHUB_USERNAME" "$DOCKERHUB_TOKEN" "$SWARM_WORKER_TOKEN" "$SWARM_MANAGER_IP_PORT"
