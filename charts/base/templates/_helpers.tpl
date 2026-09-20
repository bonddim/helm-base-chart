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
{{- $name := include "base.render.value" (dict "value" .Values.serviceAccount.name "context" .) -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "base.fullname" .) $name }}
{{- else }}
{{- default "default" $name }}
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
Target reference for autoscalers, resolving the workload type to its kind.
Emits apiVersion/kind/name, to be nindent-ed under scaleTargetRef or targetRef.
Usage: {{ include "base.targetRef" . | nindent 4 }}
*/}}
{{- define "base.targetRef" -}}
{{- if eq .Values.workload "rollout" -}}
apiVersion: argoproj.io/v1alpha1
kind: Rollout
{{- else if eq .Values.workload "statefulset" -}}
apiVersion: apps/v1
kind: StatefulSet
{{- else if eq .Values.workload "daemonset" -}}
apiVersion: apps/v1
kind: DaemonSet
{{- else if eq .Values.workload "job" -}}
apiVersion: batch/v1
kind: Job
{{- else if eq .Values.workload "cronjob" -}}
apiVersion: batch/v1
kind: CronJob
{{- else if eq .Values.workload "scaledjob" -}}
apiVersion: keda.sh/v1alpha1
kind: ScaledJob
{{- else -}}
apiVersion: apps/v1
kind: Deployment
{{- end }}
name: {{ include "base.fullname" . }}
{{- end -}}

{{/*
Defines service name used with the Argo Rollouts workload.
Usage: {{ include "base.rolloutServiceName" . }}
*/}}
{{- define "base.rolloutServiceName" -}}
{{- printf "%s-rollout" (include "base.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Name of the governing (headless) Service for a StatefulSet.
Honours an explicit `serviceName`; otherwise suffixes the fullname when the
headless Service is enabled, so it cannot collide with the main Service.
Falls back to the plain fullname when headless is disabled.
Usage: {{ include "base.headlessServiceName" . }}
*/}}
{{- define "base.headlessServiceName" -}}
{{- if .Values.serviceName -}}
{{- .Values.serviceName -}}
{{- else if .Values.service.headless.enabled -}}
{{- printf "%s-headless" (include "base.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- include "base.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Whether an autoscaler owns the replica count, in which case the workload must
not set spec.replicas and fight it.
Usage: {{ if include "base.replicasManaged" . }}
*/}}
{{- define "base.replicasManaged" -}}
{{- if or .Values.autoscaling.enabled .Values.keda.scaledObject.enabled -}}true{{- end -}}
{{- end -}}
