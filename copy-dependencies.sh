#!/usr/bin/env bash

NAME=$(basename $(pwd))

API_ID=$(docker ps --filter "name=$NAME-app" --format "{{.ID}}")
WORKER_ID=$(docker ps --filter "name=$NAME-worker" --format "{{.ID}}")
SCHEDULER_ID=$(docker ps --filter "name=$NAME-scheduler" --format "{{.ID}}")
FRONTEND_ID=$(docker ps --filter "name=$NAME-frontend" --format "{{.ID}}")

docker cp $API_ID:/usr/src/vendor ./
docker cp ./vendor $WORKER_ID:/usr/src
docker cp ./vendor $SCHEDULER_ID:/usr/src
docker cp $FRONTEND_ID:/usr/src/node_modules ./
