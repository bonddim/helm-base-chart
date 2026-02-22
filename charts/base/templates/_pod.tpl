{{- define "base.podTemplate" -}}
metadata:
  {{- with include "base.annotations" (dict "annotations" .Values.podAnnotations "context" .) }}
  annotations: {{- . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels" (dict "labels" .Values.podLabels "context" .) | nindent 4 }}
spec:
  {{- with .Values.affinity }}
  affinity: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if ne .Values.automountServiceAccountToken nil }}
  automountServiceAccountToken: {{ .Values.automountServiceAccountToken }}
  {{- end }}
  containers:
    {{- with .Values.sidecarContainers -}}
    {{- include "base.render.list" (dict "value" . "context" $) | nindent 6 }}
    {{- end }}
    - name: {{ include "base.name" . }}
      image: {{ include "base.image" . | quote }}
      {{- with .Values.image.pullPolicy }}
      imagePullPolicy: {{ . }}
      {{- end }}
      {{- with .Values.args }}
      args: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.command }}
      command: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.env }}
      env: {{- include "base.render.list" (dict "value" . "context" $) | nindent 8 }}
      {{- end }}
      {{- with .Values.envFrom }}
      envFrom: {{- include "base.render.value" (dict "value" . "context" $) | nindent 8 }}
      {{- end }}
      {{- with .Values.lifecycle }}
      lifecycle: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.livenessProbe }}
      livenessProbe: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.readinessProbe }}
      readinessProbe: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.resources }}
      resources: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.securityContext }}
      securityContext: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.startupProbe }}
      startupProbe: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if or .Values.service.port .Values.extraPorts }}
      ports:
        {{- if .Values.service.port }}
        - name: http
          containerPort: {{ .Values.service.port }}
          protocol: {{ .Values.service.protocol }}
        {{- end }}
        {{- with .Values.extraPorts }}
        {{- include "base.render.list" (dict "value" . "context" $) | nindent 8 }}
        {{- end }}
      {{- end }}
      {{- with .Values.volumeMounts }}
      volumeMounts: {{- include "base.render.list" (dict "value" . "context" $) | nindent 8 }}
      {{- end }}
  {{- with .Values.dnsPolicy }}
  dnsPolicy: {{ . }}
  {{- end }}
  {{- if ne .Values.enableServiceLinks nil }}
  enableServiceLinks: {{ .Values.enableServiceLinks }}
  {{- end }}
  {{- with .Values.imagePullSecrets }}
  imagePullSecrets: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.initContainers }}
  initContainers: {{- include "base.render.list" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
  {{- with .Values.nodeSelector }}
  nodeSelector: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.podSecurityContext }}
  securityContext: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.priorityClassName }}
  priorityClassName: {{ . }}
  {{- end }}
  serviceAccountName: {{ include "base.serviceAccountName" . }}
  {{- with .Values.terminationGracePeriodSeconds }}
  terminationGracePeriodSeconds: {{ . }}
  {{- end }}
  {{- with .Values.tolerations }}
  tolerations: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.topologySpreadConstraints }}
  topologySpreadConstraints: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.volumes }}
  volumes: {{- include "base.render.list" (dict "value" . "context" $) | nindent 4 }}
  {{- end }}
{{- end -}}
