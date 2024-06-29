FROM {{ .from_image }}
ARG user={{.os.user}}
ARG uid={{.os.uid}}

LABEL version {{ .image.tag }}
LABEL env {{ .env }}

ENV VERSION={{ .env }}

RUN php -m && echo "============================================="

RUN set -eux; \
    # workaround for rabbitmq linking issue \
    ln -s /usr/lib /usr/local/lib64; \
    apk add --no-cache --virtual .build-deps \
    ${PHPIZE_DEPS} openssl ca-certificates libxml2-dev oniguruma-dev \
    ; \
    apk add --no-cache --virtual .build-extra \
    linux-headers \
    libpq-dev \
    icu-dev

{{ template "install_tools" .install }}
{{ template "install_exts" .install }}

RUN set -eux; \
    apk del --no-network .build-deps .build-extra; \
    #    apk del --no-network .build-extra; \
    rm -rf /tmp/pear ~/.pearrc; \
    php --version; \
    php -m

{{- template "healthcheck" .healthcheck }}
{{ template "composer" .composer }}

RUN adduser -G www-data -D -u $uid -h /home/$user $user

RUN mkdir -p /home/$user/.composer && \
chown -R $user /home/$user


RUN rm -rf /var/www  && mkdir /var/www && \
rm -rf /tmp/*
