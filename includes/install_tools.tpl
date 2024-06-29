{{- define "install_tools" }}
    {{- if ne .tools "nil" }}
## Install Tools
RUN apk add --no-cache {{ .tools }}
    {{- end }}
{{- end }}