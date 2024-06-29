{{- define "install_exts" }}
    {{- if ne .exts "nil" }}
## Install PHP-Ext
RUN  --mount=type=bind,from=mlocati/php-extension-installer:latest,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
install-php-extensions {{ .exts }}
    {{- end }}
{{- end }}