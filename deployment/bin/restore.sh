#!/usr/bin/env bash

set -e

BACKUP_FILENAME=$1
POSTGRES_PASSWORD=$2

PROJECT_DIR="/usr/src"
BACKUP_DIR=$PROJECT_DIR"/storage/app/backup"

docker compose exec app s3cmd cp s3://gmdevops/$BACKUP_FILENAME $PROJECT_DIR"/storage/app/backup.zip"

docker compose exec app unzip -o $PROJECT_DIR"/storage/app/backup.zip" -d $BACKUP_DIR

docker compose exec app php $PROJECT_DIR"/artisan" down

docker compose exec --user postgres postgres dropdb devops -f
docker compose exec --user postgres postgres createdb devops
docker compose exec -e PGPASSWORD=$POSTGRES_PASSWORD app psql -h postgres -U postgres -d devops < $BACKUP_DIR"/db-dumps/postgresql-devops.sql"

docker compose exec app mv $PROJECT_DIR"/.env" $PROJECT_DIR"/.env_before_restore"
docker compose exec app mv $PROJECT_DIR"/storage/app/public" $PROJECT_DIR"/storage/app/public_before_restore"

docker compose exec app mv $BACKUP_DIR/$PROJECT_DIR"/.env" $PROJECT_DIR"/.env"
docker compose exec app mv $BACKUP_DIR/$PROJECT_DIR"/storage/app/public" $PROJECT_DIR"/storage/app/public"

docker compose exec app php $PROJECT_DIR"/artisan"  storage:link
docker compose exec app php $PROJECT_DIR"/artisan" optimize:clear

docker compose exec app php $PROJECT_DIR"/artisan" up
