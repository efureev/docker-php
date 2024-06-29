{{- define "composer" }}
    {{- if . }}

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN composer about
    {{- end }}
{{- end }}