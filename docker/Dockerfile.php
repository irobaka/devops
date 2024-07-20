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
    libssl-dev \
    postgresql-client \
    s3cmd \
    netcat-openbsd

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mbstring exif pcntl bcmath gd zip

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pgsql pdo_pgsql

RUN pecl install redis \
    && docker-php-ext-enable redis

COPY --from=composer:2.7.6 /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user

RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user && \
    chown -R $user:$user /usr/src

COPY ../composer*.json /usr/src/
COPY ../deployment/config/php-fpm/php-prod.ini /usr/local/etc/php/conf.d/php.ini
COPY ../deployment/config/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ../deployment/bin/update.sh /usr/src/update.sh
COPY ../deployment/bin/update-for-development.sh /usr/src/update-for-development.sh

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
CMD ["/bin/sh", "/usr/src/worker.sh"]

FROM dev as dev_scheduler
CMD ["/bin/sh", "/usr/src/scheduler-development.sh"]

FROM base as prod_worker
CMD ["/bin/sh", "-c", "/usr/src/worker.sh"]

FROM base as prod_scheduler
CMD ["/bin/sh", "/usr/src/scheduler.sh"]

FROM base as prod_health_check
CMD ["/bin/sh", "/usr/src/health-check.sh"]
