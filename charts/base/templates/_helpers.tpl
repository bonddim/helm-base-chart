{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "base.name" -}}
{{- default .Release.Name .Values.nameOverride . | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
Truncated to 63 chars (DNS naming spec).
If the release name already contains the chart name it is used as-is.
*/}}
{{- define "base.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := include "base.name" . }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version label value.
*/}}
{{- define "base.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Merge resource-specific annotations with commonAnnotations and render.
Usage:
  {{- with include "base.annotations" (dict "annotations" .Values.foo.annotations "context" $) }}
  annotations: {{ . | nindent n }}
  {{- end }}
*/}}
{{- define "base.annotations" -}}
{{- $merged := merge (default dict .annotations) (default dict .context.Values.commonAnnotations) }}
{{- if $merged }}
{{- toYaml $merged }}
{{- end }}
{{- end }}

{{/*
Usage:
  {{- include "base.labels" (dict "labels" .Values.foo.labels "context" $) }}
*/}}
{{- define "base.labels" -}}
{{- $labels := merge (default dict .labels) (default dict .context.Values.commonLabels) }}
{{- merge (include "base.standardLabels" .context | fromYaml) $labels | toYaml  }}
{{- end }}

{{/*
Standard labels applied to every resource.
*/}}
{{- define "base.standardLabels" -}}
{{ include "base.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "base.chart" . }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels used in matchLabels and Service selectors.
*/}}
{{- define "base.selectorLabels" -}}
app.kubernetes.io/name: {{ include "base.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Determine the ServiceAccount name to use.
*/}}
{{- define "base.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "base.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Assemble the container image reference.
Format: [registry/]repository:tag
Tag defaults to Chart.AppVersion when empty.
*/}}
{{- define "base.image" -}}
{{- $registry := coalesce .Values.global.imageRegistry .Values.image.registry }}
{{- $repository := .Values.image.repository }}
{{- $tag := coalesce .Values.image.tag .Values.global.imageTag "latest" }}
{{- if $registry }}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- else }}
{{- printf "%s:%s" $repository $tag }}
{{- end }}
{{- end }}

{{/*
Defines service name used with the Argo Rollouts workload.
Usage: {{ include "base.rolloutServiceName" . }}
*/}}
{{- define "base.rolloutServiceName" -}}
{{- printf "%s-rollout" (include "base.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}
