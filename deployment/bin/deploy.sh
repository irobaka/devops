#!/usr/bin/env bash

set -e

cd /usr/src

export $(cat .env)
docker stack deploy -c docker-compose.yml devops
#rm .env
