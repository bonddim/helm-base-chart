{{/*
Shared Job spec, used directly by the Job workload and nested under the
CronJob's jobTemplate. Every field is omitted unless set, so the cluster
defaults apply.
Usage: {{ include "base.jobSpec" . | nindent 2 }}
*/}}
{{- define "base.jobSpec" -}}
{{- if ne .Values.job.backoffLimit nil }}
backoffLimit: {{ .Values.job.backoffLimit }}
{{- end }}
{{- if ne .Values.job.completions nil }}
completions: {{ .Values.job.completions }}
{{- end }}
{{- with .Values.job.completionMode }}
completionMode: {{ . }}
{{- end }}
{{- if ne .Values.job.parallelism nil }}
parallelism: {{ .Values.job.parallelism }}
{{- end }}
{{- if ne .Values.job.activeDeadlineSeconds nil }}
activeDeadlineSeconds: {{ .Values.job.activeDeadlineSeconds }}
{{- end }}
{{- if ne .Values.job.ttlSecondsAfterFinished nil }}
ttlSecondsAfterFinished: {{ .Values.job.ttlSecondsAfterFinished }}
{{- end }}
{{- if ne .Values.job.suspend nil }}
suspend: {{ .Values.job.suspend }}
{{- end }}
{{- with .Values.job.podFailurePolicy }}
podFailurePolicy: {{- toYaml . | nindent 2 }}
{{- end }}
template: {{- include "base.podTemplate" . | nindent 2 }}
{{- end -}}
