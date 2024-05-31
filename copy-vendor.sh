#!/usr/bin/env bash

NAME=$(basename $(pwd))
ID=$(docker ps --filter "name=$NAME-app" --format "{{.ID}}")
if [ ${#ID} -gt 0 ]; then
    docker cp $ID:/usr/src/vendor ./
fi
