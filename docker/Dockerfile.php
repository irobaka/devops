FROM php:8.2-fpm as base

WORKDIR /usr/src

ARG user
ARG uid

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    git \
    curl \
    zip \
    unzip \
    supervisor \
    libssl-dev \
    postgresql-client

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mbstring exif pcntl bcmath gd zip

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pgsql pdo_pgsql

RUN pecl install redis

COPY --from=composer:2.7.6 /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user

RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user && \
    chown -R $user:$user /usr/src

COPY ../composer*.json /usr/src/
COPY ../deployment/config/php-fpm/php.ini /usr/local/etc/php/conf.d/php.ini
COPY ../deployment/config/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ../deployment/bin/update.sh /usr/src/update.sh

RUN composer install --no-scripts

COPY .. .

RUN php artisan storage:link && \
    chmod +x ./update.sh && \
    chown -R $user:$user /usr/src && \
    chmod -R 775 ./storage ./bootstrap/cache

USER $user

FROM base as dev
USER root

RUN pecl install xdebug && docker-php-ext-enable xdebug

COPY ../deployment/config/php-fpm/x-debug.ini /usr/local/etc/php/conf.d/docker-x-debug.ini

USER $user

FROM node:18.20.2-alpine as assets

WORKDIR /usr/src
COPY ../package.json ../package-lock.json ./
RUN npm install
COPY .. .
RUN npm run build

FROM dev as prod
COPY --from=assets /usr/src/public/build ./public/build

FROM dev as dev_worker
COPY ../deployment/config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisor.conf
CMD ["/bin/sh", "-c", "supervisord -c /etc/supervisor/conf.d/supervisor.conf"]

FROM dev as dev_scheduler
CMD ["/bin/sh", "-c", "nice -n 10 sleep 60 && php /usr/src/artisan schedule:run --verbose --no-interaction"]

FROM base as prod_worker
COPY ../deployment/config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisor.conf
CMD ["/bin/sh", "-c", "supervisord -c /etc/supervisor/conf.d/supervisor.conf"]

FROM base as prod_scheduler
CMD ["/bin/sh", "-c", "nice -n 10 sleep 60 && php /usr/src/artisan schedule:run --verbose --no-interaction"]
