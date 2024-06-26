#!/usr/bin/env bash

set -e

BACKUP_FILENAME=$1

PROJECT_DIR="/usr/src"
BACKUP_DIR=$PROJECT_DIR"/storage/app/backup"

cd /usr/src

read_env() {
  local filePath=".env"

  if [ ! -f "$filePath" ]; then
    echo "missing ${filePath}"
    exit 1
  fi

  echo "Reading $filePath"
  while read -r LINE; do
    # Remove leading and trailing whitespaces, and carriage return
    CLEANED_LINE=$(echo "$LINE" | awk '{$1=$1};1' | tr -d '\r')

    if [[ $CLEANED_LINE != '#'* ]] && [[ $CLEANED_LINE == *'='* ]]; then
      export "$CLEANED_LINE"
    fi
  done < "$filePath"
}

read_env

docker compose exec app s3cmd --access_key=$AWS_ACCESS_KEY_ID --secret_key=$AWS_SECRET_ACCESS_KEY --region=$AWS_DEFAULT_REGION --host=$AWS_DEFAULT_REGION.digitaloceanspaces.com --host-bucket="%(bucket)s.$AWS_DEFAULT_REGION.digitaloceanspaces.com" get s3://$AWS_BUCKET/$BACKUP_FILENAME $PROJECT_DIR"/storage/app/backup.zip"

docker compose exec app unzip -o $PROJECT_DIR"/storage/app/backup.zip" -d $BACKUP_DIR
docker compose exec app rm $PROJECT_DIR"/storage/app/backup.zip"

docker compose exec app php $PROJECT_DIR"/artisan" down

docker compose exec --user postgres postgres dropdb devops -f
docker compose exec --user postgres postgres createdb devops

docker compose exec -e PGPASSWORD=$DB_PASSWORD app pg_restore -h postgres -U postgres -d devops  $BACKUP_DIR/db-dumps/postgresql-devops.sql

docker compose exec app cp $PROJECT_DIR"/.env" $PROJECT_DIR"/.env_before_restore"
docker compose exec app mv $PROJECT_DIR"/storage/app/public" $PROJECT_DIR"/storage/app/public_before_restore"

docker compose exec app cp $BACKUP_DIR/$PROJECT_DIR"/.env" $PROJECT_DIR"/.env"
docker compose exec app mv $BACKUP_DIR/$PROJECT_DIR"/storage/app/public" $PROJECT_DIR"/storage/app/public"

docker compose exec app rm -rf $PROJECT_DIR"/storage/app/backup"

docker compose exec app php $PROJECT_DIR"/artisan" storage:link
docker compose exec app php $PROJECT_DIR"/artisan" optimize:clear
docker compose exec app php $PROJECT_DIR"/artisan" config:cache
docker compose exec app php $PROJECT_DIR"/artisan" route:cache
docker compose exec app php $PROJECT_DIR"/artisan" view:cache
docker compose exec app php $PROJECT_DIR"/artisan" event:cache

docker compose exec app php $PROJECT_DIR"/artisan" up
