{{/*
Renders any value with template.
Usage:
  {{ include "base.render.value" (dict "value" .Values.foo "context" $) }}
*/}}
{{- define "base.render.value" -}}
{{- $value := typeIs "string" .value | ternary .value (toYaml .value) }}
{{- contains "{{" (toJson .value) | ternary (tpl $value .context) $value }}
{{- end }}

{{/*
Renders a list or map with template.
If the value is a list, it will be rendered as a list
If the value is a map, it will be rendered as a list of maps with a "name" field.
If the value is a string, it will be rendered as a string.
Usage:
  {{- include "base.render.list" (dict "value" .Values.listValue "context" $) }}
  {{- include "base.render.list" (dict "value" .Values.mapValue "context" $) }}
  {{- include "base.render.list" (dict "value" .Values.stringValue "context" $) }}
*/}}
{{- define "base.render.list" -}}
{{- $ctx := .context }}
{{- if kindIs "slice" .value }}
  {{- include "base.render.value" (dict "value" .value "context" $ctx) }}
{{- else }}
  {{- $result := list }}
  {{- range $name, $value := .value }}
    {{- if kindIs "string" $value }}
      {{- $rendered := include "base.render.value" (dict "value" $value "context" $ctx) }}
      {{- $result = append $result (dict "name" $name "value" $rendered) }}
    {{- else }}
      {{- $rendered := include "base.render.value" (dict "value" $value "context" $ctx) | fromYaml }}
      {{- $result = append $result (set $rendered "name" $name) }}
    {{- end }}
  {{- end }}
  {{- toYaml $result }}
{{- end }}
{{- end }}
