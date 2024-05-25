#!/usr/bin/env bash

set -e

BACKUP_FILENAME=$1

PROJECT_DIR="var/www/html/devops"
BACKUP_DIR=$PROJECT_DIR"/storage/app/backup"

s3cmd cp s3://gmdevops/$BACKUP_FILENAME $PROJECT_DIR"/storage/app/backup.zip"

unzip -o $PROJECT_DIR"/storage/app/backup.zip" -d $BACKUP_DIR

php $PROJECT_DIR"/artisan" down

sudo -u postgres dropdb devops -f
sudo -u postgres createdb devops
sudo -u postgres psql -d devops < $BACKUP_DIR"/db-dumps/postgresql-devops.sql"

mv $PROJECT_DIR"/.env" $PROJECT_DIR"/.env_before_restore"
mv $PROJECT_DIR"/storage/app/public" $PROJECT_DIR"/storage/app/public_before_restore"

mv $BACKUP_DIR/$PROJECT_DIR"/.env" $PROJECT_DIR"/.env"
mv $BACKUP_DIR/$PROJECT_DIR"/storage/app/public" $PROJECT_DIR"/storage/app/public"

php $PROJECT_DIR"/artisan"  storage:link
php $PROJECT_DIR"/artisan" optimize:clear

php $PROJECT_DIR"/artisan" up







