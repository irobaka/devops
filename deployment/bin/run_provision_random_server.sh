#!/usr/bin/env bash

set -ex

NAME=$1
SIZE=${2:-s-1vcpu-1gb}

SSH_FINGERPRINT=$(doctl compute ssh-key list --no-header | grep "legion5pro-ubuntu24" | awk '{ print $3 }')

PUBLIC_SSH_KEY=$(cat $HOME/.ssh/id_ed25519.pub)

DROPLET_ID=$(doctl compute droplet create $NAME --size $SIZE --image ubuntu-24-04-x64 --region fra1 --ssh-keys $SSH_FINGERPRINT --wait --no-header --format=ID)

doctl projects resources assign 1dfbd682-6e4d-416d-8be1-8eec2f816cac --resource=do:droplet:$DROPLET_ID

sleep 30

SERVER_IP=$(doctl compute droplet get $DROPLET_ID --format PublicIPv4 --no-header)

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 ./provision_server.sh root@$SERVER_IP:./provision_server.sh
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_ed25519 root@$SERVER_IP "chmod +x ./provision_server.sh && ./provision_server.sh \"$PUBLIC_SSH_KEY\""
