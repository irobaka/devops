#!/usr/bin/env bash

set -e

POSTGRES_PASSWORD=$1

PROJECT_DIR="/var/www/html/devops"

# make dir if not exists (first deploy)
mkdir -p $PROJECT_DIR

cd $PROJECT_DIR

git config --global --add safe.directory $PROJECT_DIR

# the project has not been cloned yet (first deploy)
if [ ! -d $PROJECT_DIR"/.git" ]; then
    GIT_SSH_COMMAND='ssh -i /home/devops/.ssh/id_devops -o IdentifiesOnly=yes' git clone git@github.com:irobaka/devops.git .
else
    GIT_SSH_COMMAND='ssh -i /home/devops/.ssh/id_devops -o IdentifiesOnly=yes' git pull
fi

npm install
npm run build

composer install --no-interaction --optimize-autoloader --no-dev

if [ ! -f $PROJECT_DIR"/.env" ]; then
    cp .env.example .env
    sed -i "/DB_PASSWORD/c\DB_PASSWORD=$POSTGRES_PASSWORD" $PROJECT_DIR"/.env"
    sed -i "/QUEUE_CONNECTION/c\QUEUE_CONNECTION=database" $PROJECT_DIR"/.env"
    php artisan key:generate
fi

chown -R www-data:www-data $PROJECT_DIR

php artisan storage:link
php artisan optimize:clear

php artisan down

php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache

php artisan up

sudo cp $PROJECT_DIR"/deployment/config/php-fpm/www.conf" /etc/php/8.2/fpm/pool.d/www.conf
sudo cp $PROJECT_DIR"/deployment/config/php-fpm/php.ini" /etc/php/8.2/fpm/conf.d/php.ini
sudo systemctl restart php8.2-fpm.service

sudo cp $PROJECT_DIR"/deployment/config/nginx.conf" /etc/nginx/nginx.conf
sudo nginx -t
sudo systemctl reload nginx

sudo cp $PROJECT_DIR"/deployment/config/supervisor/supervisord.conf" /etc/supervisor/conf.d/supervisord.conf
sudo supervisorctl update
sudo supervisorctl restart workers:


