FROM php:8.3-fpm-alpine3.19

ARG user=app
ARG uid=1000

RUN set -eux; \
    # workaround for rabbitmq linking issue \
    ln -s /usr/lib /usr/local/lib64; \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    ; \
    apk add --no-cache --virtual .build-extra \
        libpq-dev \
        icu-dev \
    ; \
    apk add --no-cache \
        fcgi \
        bash \
    ; \
    pecl update-channels; \
    pecl install --onlyreqdeps --force redis excimer; \
    docker-php-ext-install pdo_pgsql pgsql intl; \
    docker-php-ext-enable redis; \
    apk del --no-network .build-deps; \
    apk del --no-network .build-extra; \
    rm -rf /tmp/pear ~/.pearrc; \
    php --version

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

USER $user


