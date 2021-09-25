FROM php:8.0.11-fpm

RUN docker-php-ext-install bcmath

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini