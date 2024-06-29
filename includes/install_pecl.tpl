{{- define "install_pecl" }}
    {{- if ne .pecl "nil" }}
RUN set -eux; \
    pecl update-channels; \
    pecl install --onlyreqdeps --force {{ .pecl }}; \
    docker-php-ext-enable {{ .pecl }}
    {{- end }}
{{- end }}