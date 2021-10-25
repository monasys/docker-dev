FROM php:8.0.11-fpm-alpine3.14

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

ARG UID

ARG UNIX_PASSWD

RUN docker-php-ext-install pdo_mysql mysqli \ 
    && apk --no-cache add pcre-dev ${PHPIZE_DEPS} \ 
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> \ 
    /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && apk del pcre-dev ${PHPIZE_DEPS} \
    && apk --no-cache add sudo vim npm git \
    && adduser --disabled-password --gecos "" --uid $UID user \
    && echo "%user ALL=(ALL) ALL" > /etc/sudoers.d/user \
    && echo user:$UNIX_PASSWD | chpasswd

USER user