FROM php:8.0.11-fpm

RUN docker-php-ext-install bcmath

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

EXPOSE 9003

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host = host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini