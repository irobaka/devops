#!/usr/bin/env bash

set -e

POSTGRES_PASSWORD=$1
SSH_KEY=$2

PROJECT_DIR="/var/www/html/devops"

mkdir -p $PROJECT_DIR
chown -R www-data:www-data $PROJECT_DIR
cd $PROJECT_DIR

rm -f /usr/bin/node
rm -f /usr/bin/npm
rm -f /usr/bin/npx

cd /usr/lib
wget https://nodejs.org/dist/v20.13.1/node-v20.13.1-linux-x64.tar.xz
tar xf node-v20.13.1-linux-x64.tar.xz
rm node-v20.13.1-linux-x64.tar.xz
mv ./node-v20.13.1-linux-x64/bin/node /usr/bin/node
ln -s /usr/lib/node-v20.13.1-linux-x64/lib/node_modules/npm/bin/npm-cli.js /usr/bin/npm
ln -s /usr/lib/node-v20.13.1-linux-x64/lib/node_modules/npm/bin/npx-cli.js /usr/bin/npx

add-apt-repository ppa:ondrej/php -y

apt update -y
apt upgrade -y

apt install nginx -y

apt install php8.2-common php8.2-cli -y
apt install php8.2-dom -y
apt install php8.2-gd -y
apt install php8.2-zip -y
apt install php8.2-curl -y
apt install php8.2-pgsql -y
apt install php8.2-sqlite3 -y
apt install php8.2-mbstring -y
apt install php8.2-fpm -y

apt install net-tools -y
apt install supervisor -y
apt install unzip

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/bin/composer

apt install postgresql -y postgresql-contrib

sudo -u postgres psql -U postgres -c "alter user postgres with password '$POSTGRES_PASSWORD';"
sudo -u postgres psql -U postgres <<<"SELECT 'CREATE DATABASE devops' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'devops') \gexec"

echo "* * * * * cd $PROJECT_DIR && php artisan schedule:run >> /dev/null 2>&1" >> cron_tmp
crontab cron_tmp
rm cron_tmp

if id -u "devops" >/dev/null 2>&1; then
    echo 'user exists'
else
    useradd -G www-data,root -u 1000 -d /home/devops devops
    mkdir -p /home/devops/.ssh
    touch /home/devops/.ssh/authorized_keys
    echo 'user added'
fi

chown -R devops:devops /home/devops
chmod 700 /home/devops/.ssh
chmod 644 /home/devops/.ssh/authorized_keys

echo "$SSH_KEY" >> "/home/devops/.ssh/authorized_keys"

echo "devops ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/devops

php -v
node -v
npm -v

