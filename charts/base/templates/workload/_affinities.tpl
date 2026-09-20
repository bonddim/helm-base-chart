{{/*
Topology key used by the pod affinity/anti-affinity presets.
Usage: {{ include "base.affinities.topologyKey" (dict "context" $) }}
*/}}
{{- define "base.affinities.topologyKey" -}}
{{- default "kubernetes.io/hostname" .context.Values.affinityTopologyKey -}}
{{- end -}}

{{/*
Node affinity calculated from `nodeAffinityPreset`.
Empty unless both a `soft`/`hard` type and a key are set.
Usage: {{ include "base.affinities.node" (dict "context" $) }}
*/}}
{{- define "base.affinities.node" -}}
{{- $preset := default dict .context.Values.nodeAffinityPreset -}}
{{- $type := default "" $preset.type -}}
{{- $key := default "" $preset.key -}}
{{- if and $key (has $type (list "soft" "hard")) -}}
{{- $matchExpressions := list (dict "key" $key "operator" "In" "values" (default list $preset.values)) -}}
{{- if eq $type "soft" -}}
{{- $term := dict "weight" 1 "preference" (dict "matchExpressions" $matchExpressions) -}}
{{- toYaml (dict "preferredDuringSchedulingIgnoredDuringExecution" (list $term)) -}}
{{- else -}}
{{- $terms := dict "nodeSelectorTerms" (list (dict "matchExpressions" $matchExpressions)) -}}
{{- toYaml (dict "requiredDuringSchedulingIgnoredDuringExecution" $terms) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Pod affinity or anti-affinity calculated from a `soft`/`hard` preset,
selecting on this release's own pods. Empty for any other value.
Usage: {{ include "base.affinities.pod" (dict "preset" "soft" "context" $) }}
*/}}
{{- define "base.affinities.pod" -}}
{{- $ctx := .context -}}
{{- $preset := default "" .preset -}}
{{- $labelSelector := dict "matchLabels" (include "base.selectorLabels" $ctx | fromYaml) -}}
{{- $topologyKey := include "base.affinities.topologyKey" (dict "context" $ctx) -}}
{{- if eq $preset "soft" -}}
{{- $term := dict "weight" 1 "podAffinityTerm" (dict "labelSelector" $labelSelector "topologyKey" $topologyKey) -}}
{{- toYaml (dict "preferredDuringSchedulingIgnoredDuringExecution" (list $term)) -}}
{{- else if eq $preset "hard" -}}
{{- $term := dict "labelSelector" $labelSelector "topologyKey" $topologyKey -}}
{{- toYaml (dict "requiredDuringSchedulingIgnoredDuringExecution" (list $term)) -}}
{{- end -}}
{{- end -}}

{{/*
Pod affinity block. Raw `.Values.affinity` wins outright; otherwise the block
is assembled from the presets above. Everything is passed through
`base.render.value`, so both raw and preset values may embed Helm expressions.
Returns an empty string when nothing is configured, so callers guard with `with`.
Usage: {{ include "base.affinity" (dict "context" $) }}
*/}}
{{- define "base.affinity" -}}
{{- $ctx := .context -}}
{{- if $ctx.Values.affinity -}}
{{- include "base.render.value" (dict "value" $ctx.Values.affinity "context" $ctx) -}}
{{- else -}}
{{- $affinity := dict -}}
{{- $sections := dict
  "nodeAffinity" (include "base.affinities.node" (dict "context" $ctx))
  "podAffinity" (include "base.affinities.pod" (dict "preset" $ctx.Values.podAffinityPreset "context" $ctx))
  "podAntiAffinity" (include "base.affinities.pod" (dict "preset" $ctx.Values.podAntiAffinityPreset "context" $ctx))
-}}
{{- range $name, $yaml := $sections -}}
{{- if $yaml -}}
{{- $_ := set $affinity $name (fromYaml $yaml) -}}
{{- end -}}
{{- end -}}
{{- if $affinity -}}
{{- include "base.render.value" (dict "value" $affinity "context" $ctx) -}}
{{- end -}}
{{- end -}}
{{- end -}}
