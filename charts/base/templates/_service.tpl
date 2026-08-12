{{/*
Render a Service from the shared service.* spec.
Usage:
  {{ include "base.service" (dict "context" . "name" (include "base.fullname" .)) }}
*/}}
{{- define "base.service" -}}
apiVersion: v1
kind: Service
metadata:
  {{- with include "base.annotations" (dict "annotations" .context.Values.service.annotations "context" .context) }}
  annotations: {{- . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels" (dict "labels" .context.Values.service.labels "context" .context) | nindent 4 }}
  name: {{ .name }}
spec:
  {{- with .context.Values.service.clusterIP }}
  clusterIP: {{ . }}
  {{- end }}
  {{- with .context.Values.service.externalIPs }}
  externalIPs: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .context.Values.service.externalName }}
  externalName: {{ . }}
  {{- end }}
  {{- with .context.Values.service.externalTrafficPolicy }}
  externalTrafficPolicy: {{ . }}
  {{- end }}
  {{- with .context.Values.service.healthCheckNodePort }}
  healthCheckNodePort: {{ . }}
  {{- end }}
  {{- with .context.Values.service.loadBalancerIP }}
  loadBalancerIP: {{ . }}
  {{- end }}
  {{- with .context.Values.service.loadBalancerSourceRanges }}
  loadBalancerSourceRanges: {{- toYaml . | nindent 4 }}
  {{- end }}
  ports:
    - name: http
      port: {{ .context.Values.service.port }}
      targetPort: {{ .context.Values.service.targetPort }}
      protocol: {{ .context.Values.service.protocol }}
      {{- with .context.Values.service.nodePort }}
      nodePort: {{ . }}
      {{- end }}
    {{- with .context.Values.service.extraPorts }}
    {{- include "base.render.list" (dict "value" . "context" .context) | nindent 4 }}
    {{- end }}
  {{- with .context.Values.service.publishNotReadyAddresses }}
  publishNotReadyAddresses: {{ . }}
  {{- end }}
  selector: {{- include "base.selectorLabels" .context | nindent 4 }}
  {{- with .context.Values.service.sessionAffinity }}
  sessionAffinity: {{ . }}
  {{- end }}
  {{- with .context.Values.service.sessionAffinityConfig }}
  sessionAffinityConfig: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .context.Values.service.topologyKeys }}
  topologyKeys: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .context.Values.service.type}}
  type: {{ . }}
  {{- end }}
{{- end }}
