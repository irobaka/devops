#!/usr/bin/env bash

set -e

cd /usr/src

sudo docker compose -f docker-compose.prod.yml down
sudo docker compose -f docker-compose.prod.yml up -d --remove-orphans
sudo docker compose -f docker-compose.prod.yml exec -T app php artisan config:cache
sudo docker compose -f docker-compose.prod.yml exec -T app php artisan route:cache
sudo docker compose -f docker-compose.prod.yml exec -T app php artisan view:cache
sudo docker compose -f docker-compose.prod.yml exec -T app php artisan event:cache
