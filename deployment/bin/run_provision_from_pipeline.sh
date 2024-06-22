#!/usr/bin/env bash

set -ex

NAME=$1
DOCTL_TOKEN=$2
SSH_KEY_PRIVATE_LOCATION=$3
SIZE=${4:-s-1vcpu-1gb}

wget https://github.com/digitalocean/doctl/releases/download/v1.107.0/doctl-1.107.0-linux-amd64.tar.gz
tar xf ./doctl-1.107.0-linux-amd64.tar.gz
mv ./doctl /usr/local/bin

EXISTING_DROPLET=$(doctl compute droplet list --access-token $DOCTL_TOKEN | grep $NAME)

COUNT=${#EXISTING_DROPLET}

if [ "$COUNT" -gt 0 ]; then
  echo "Droplet already exists"
  SERVER_IP=$(echo $EXISTING_DROPLET | awk '{ print $3 }')
  echo $SERVER_IP
  exit 0
fi


SSH_FINGERPRINT=$(doctl compute ssh-key list --no-header --access-token $DOCTL_TOKEN | grep "legion5pro" | awk '{ print $3 }')

DROPLET_ID=$(doctl compute droplet create $NAME --size $SIZE --image ubuntu-24-04-x64 --region fra1 --ssh-keys $SSH_FINGERPRINT --wait --no-header --format=ID --access-token $DOCTL_TOKEN)

#doctl projects resources assign 1dfbd682-6e4d-416d-8be1-8eec2f816cac --resource=do:droplet:$DROPLET_ID

sleep 30

SERVER_IP=$(doctl compute droplet get $DROPLET_ID --format PublicIPv4 --no-header --access-token $DOCTL_TOKEN)

scp -C -o StrictHostKeyChecking=no -i $SSH_KEY_PRIVATE_LOCATION/id_rsa ./provision_server.sh root@$SERVER_IP:./provision_server.sh
ssh -tt -o StrictHostKeyChecking=no -i $SSH_KEY_PRIVATE_LOCATION/id_rsa root@$SERVER_IP "chmod +x ./provision_server.sh && ./provision_server.sh"

echo $SERVER_IP
