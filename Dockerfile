FROM php:8.3-fpm-alpine3.18

ARG user=app
ARG uid=1000

ENV PHPIZE_DEPS \
    pcre-dev \
    libc-dev \
    libpq-dev \
    autoconf \
    icu-dev \
    g++ \
    gcc \
    make \
    cmake \
    libtool

RUN apk add --update --no-cache $PHPIZE_DEPS

RUN apk add --no-cache \
    bash \
    curl \
    fcgi


RUN \
    pear update-channels && \
    pecl channel-update pecl.php.net && \
    docker-php-ext-install intl

RUN docker-php-ext-install pdo_pgsql pgsql \
    && pecl install redis \
    && pecl install excimer \
    && docker-php-ext-enable redis.so


RUN set -eux; \
	{ \
		echo '[www]'; \
		echo 'ping.path = /ping'; \
	} | tee /usr/local/etc/php-fpm.d/docker-healthcheck.conf

COPY docker/php/docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


# Create system user to run Composer and Artisan Commands
#RUN #useradd -G www-data,root -u $uid -d /home/$user $user
RUN adduser -G www-data -D -u $uid -h /home/$user $user

RUN mkdir -p /home/$user/.composer && \
    chown -R $user /home/$user


RUN rm -rf /var/www  && mkdir /var/www && \
    rm -rf /tmp/*

WORKDIR /var/www/app

RUN chown -R $user /var/www/app

USER $user


