FROM php:8.3-fpm-alpine3.19

ARG user=app
ARG uid=1000

######## [PHP Modules] Default ########
#### Core
#### ctype
#### curl
#### date
#### dom
#### fileinfo
#### filter
#### hash
#### iconv
#### json
#### libxml
#### mbstring
#### mysqlnd
#### openssl
#### pcre
#### PDO
#### pdo_sqlite
#### Phar
#### posix
#### random
#### readline
#### Reflection
#### session
#### SimpleXML
#### sodium
#### SPL
#### sqlite3
#### standard
#### tokenizer
#### xml
#### xmlreader
#### xmlwriter
#### zlib


RUN php -m && echo "============================================="

######## [PHP Modules] will be install ########
#### excimer
#### exif
#### intl
#### opcache
#### pdo_pgsql
#### pgsql
#### redis

######## Ext Dependencies ########
#### intl: icu-dev
#### intl: icu-dev
#### pdo_pgsql: libpq-dev
#### pgsql: libpq-dev
#### pgsql: libpq-dev

######## Potentials Ext ########
#### bzip2-dev: bz2
#### enchant2-dev: enchant
#### gd: libpng-dev
#### gmp: gmp-dev
#### imap: imap-dev
#### ldap: openldap-dev
#### pdo_dblib: freetds-dev
#### pspell: aspell-dev
#### snmp: net-snmp-dev
#### soap: libxml2-dev
#### tidy: tidyhtml-dev
#### xsl: libxslt-dev
#### zip: libzip-dev

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
    docker-php-ext-install intl pdo_pgsql pgsql exif opcache; \
    docker-php-ext-enable redis excimer intl pdo_pgsql pgsql opcache; \
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
#HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN composer about

# Create system user to run Composer and Artisan Commands
#RUN #useradd -G www-data,root -u $uid -d /home/$user $user
RUN adduser -G www-data -D -u $uid -h /home/$user $user

RUN mkdir -p /home/$user/.composer && \
    chown -R $user /home/$user


RUN rm -rf /var/www  && mkdir /var/www && \
    rm -rf /tmp/*

