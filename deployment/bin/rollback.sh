#!/usr/bin/env bash

IMAGE_TAG=$1

cd /usr/src
b
sed -i "/IMAGE_TAG/c\IMAGE_TAG=$IMAGE_TAG" /usr/src/.env

sudo docker-compose -f docker-compose.yml down
sudo docker-compose -f docker-compose.yml up -d --remove-orphans
