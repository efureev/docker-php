{{- define "healthcheck" }}
    {{- if .install }}
## Install Healthcheck
RUN set -eux; \
    { \
    echo '[www]'; \
    echo 'ping.path = /ping'; \
    } | tee /usr/local/etc/php-fpm.d/configs-healthcheck.conf

COPY configs/php/docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck

        {{- if .enable }}
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]
        {{- end }}
    {{- end }}
{{- end }}