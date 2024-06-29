{{- define "composer" }}
    {{- if . }}
ENV COMPOSER_ALLOW_SUPERUSER 1

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN set -eux ; \
    composer about; \
    composer --ansi --version --no-interaction ; \
    composer diagnose || 0
    {{- end }}
{{- end }}