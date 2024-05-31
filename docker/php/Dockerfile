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
    libssl-dev

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

COPY ../../deployment/config/php-fpm/php.ini /usr/local/etc/php/conf.d/php.ini
COPY ../../deployment/config/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf

USER $user

FROM base as dev
USER root

RUN pecl install xdebug && docker-php-ext-enable xdebug

COPY ../../deployment/config/php-fpm/x-debug.ini /usr/local/etc/php/conf.d/docker-x-debug.ini

USER $user

FROM base as prod
COPY ../.. .
RUN composer install


FROM dev as dev_worker
CMD ["/bin/sh", "-c", "nice -n 10 php /usr/src/artisan queue:work --tries=3 --verbose --timeout=30 --sleep=3 --rest=1 --max-jobs=1000 --max-time=3600"]

FROM dev as dev_scheduler
CMD ["/bin/sh", "-c", "nice -n 10 sleep 60 && php /usr/src/artisan schedule:run --verbose --no-interaction"]

FROM prod as prod_worker
CMD ["/bin/sh", "-c", "nice -n 10 php /usr/src/artisan queue:work --tries=3 --verbose --timeout=30 --sleep=3 --rest=1 --max-jobs=1000 --max-time=3600"]

FROM prod as prod_scheduler
CMD ["/bin/sh", "-c", "nice -n 10 sleep 60 && php /usr/src/artisan schedule:run --verbose --no-interaction"]
