# base

![Version: 0.5.0](https://img.shields.io/badge/Version-0.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Base Helm chart for Kubernetes - fully values-driven.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| bonddim |  |  |

## Source Code

* <https://github.com/bonddim/helm-base-chart>

## Values

### Global parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.imageRegistry | string | `""` | Global image registry. Used as the default for all charts, but can be overridden by individual chart values. |
| global.imageTag | string | `""` | Global image tag used as the default for all charts. Can be overridden by individual chart values. |

### Common parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Override resource names (partially) |
| fullnameOverride | string | `""` | Override resource names (fully) |
| commonLabels | object | `{}` | Labels to add to all deployed resources |
| commonAnnotations | object | `{}` | Annotations to add to all deployed resources |

### Workload parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| workload | string | `"deployment"` | Workload type to deploy. One of: deployment, daemonset, statefulset, rollout, job, cronjob, pod or null |
| annotations | object | `{}` | Additional annotations on the Workload resource itself. |
| labels | object | `{}` | Additional labels on the Deployment resource itself. |
| replicas | int | `nil` | Number of pod replicas. Ignored when autoscaling.enabled=true. Must be >= 0 if specified. null by default, which defaults to 1 and not controlled by Helm. |
| strategy | object | `{}` | Update strategy for the selected workload. e.g. { type: RollingUpdate, rollingUpdate: { maxSurge: 1, maxUnavailable: 0 } }. For workload=rollout, the chart merges Service references into this strategy: `stableService`/`activeService`. |
| serviceName | string | `""` | StatefulSet service name. Defaults to the fullname when empty. |
| podManagementPolicy | string | `""` | StatefulSet pod management policy: OrderedReady or Parallel. |
| volumeClaimTemplates | list | `[]` | StatefulSet volumeClaimTemplates for persistent storage. |
| persistentVolumeClaimRetentionPolicy | object | `{}` | StatefulSet persistentVolumeClaimRetentionPolicy. |
| revisionHistoryLimit | int | `nil` | Number of old ReplicaSets to retain. |
| podAnnotations | object | `{}` | Additional annotations on the Pod template. |
| podLabels | object | `{}` | Additional labels on the Pod template. |
| podSecurityContext | object | `{}` | Pod-level security context. |
| imagePullSecrets | list | `[]` | Image pull secrets (list of { name: ... }). |
| automountServiceAccountToken | bool | `nil` | Whether to auto-mount the service account token to the pod. |
| initContainers | object/list | `{}` | Init containers (values are tpl-rendered). |
| sidecarContainers | object/list | `{}` | Sidecar containers (values are tpl-rendered). |
| volumes | object/list | `{}` | Volumes (values are tpl-rendered). |
| nodeSelector | object | `{}` | Node selector for pod scheduling. |
| tolerations | list | `[]` | Tolerations for pod scheduling. |
| affinity | object | `{}` | Raw pod affinity/anti-affinity rules (tpl-rendered). When set, this replaces the calculated presets below entirely. |
| podAffinityPreset | string | `""` | Calculated pod affinity preset: `soft`, `hard`, or empty to disable. Co-locates replicas of this release. |
| podAntiAffinityPreset | string | `""` | Calculated pod anti-affinity preset: `soft`, `hard`, or empty to disable. Spreads replicas of this release apart. |
| nodeAffinityPreset | object | `{"key":"","type":"","values":[]}` | Calculated node affinity preset, e.g. `{ type: soft, key: topology.kubernetes.io/zone, values: [eu-central-1a] }`. Requires both type (`soft`/`hard`) and key. |
| affinityTopologyKey | string | `""` | Topology key used by the pod affinity/anti-affinity presets. Defaults to kubernetes.io/hostname. |
| topologySpreadConstraints | list | `[]` | Topology spread constraints. |
| restartPolicy | string | `""` | Pod restart policy. Defaults to Never for job/cronjob workloads, and to the cluster default otherwise. |
| dnsPolicy | string | `""` | DNS policy for the pod. |
| priorityClassName | string | `""` | Priority class name. |
| terminationGracePeriodSeconds | int | `nil` | Grace period (seconds) before forceful termination. |
| enableServiceLinks | bool | `nil` | Enable Kubernetes service links injected as env vars. |
| image.registry | string | `""` | Container image registry. |
| image.repository | string | `""` | Container image repository. |
| image.tag | string | `""` | Container image tag. Defaults to Chart.AppVersion when empty. @default latest |
| image.pullPolicy | string | `nil` | Image pull policy. |
| command | list | `[]` | Override the container entrypoint. |
| args | list | `[]` | Arguments to the entrypoint. |
| env | object/list | `{}` | Environment variables (tpl-rendered). |
| envFrom | list | `[]` | envFrom sources (tpl-rendered). |
| extraPorts | object/list | `{}` | Extra ports in addition to the primary port derived from service.port. |
| resources | object | `{}` | Compute resource requests and limits. |
| securityContext | object | `{}` | Container-level security context. |
| livenessProbe | object | `{}` | Liveness probe configuration. |
| readinessProbe | object | `{}` | Readiness probe configuration. |
| startupProbe | object | `{}` | Startup probe configuration. |
| lifecycle | object | `{}` | Container lifecycle hooks. |
| volumeMounts | object/list | `{}` | Volume mounts (tpl-rendered). Key = volume name. |

### Job parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| job.backoffLimit | int | `nil` | Number of retries before marking the Job failed. |
| job.completions | int | `nil` | Number of successful completions required. |
| job.completionMode | string | `""` | Completion mode: NonIndexed or Indexed. |
| job.parallelism | int | `nil` | Number of pods to run in parallel. |
| job.activeDeadlineSeconds | int | `nil` | Seconds the Job may run before it is terminated. |
| job.ttlSecondsAfterFinished | int | `nil` | Seconds after finishing before the Job is eligible for automatic deletion. |
| job.suspend | bool | `nil` | Suspend the Job without deleting it. |
| job.podFailurePolicy | object | `{}` | Rules for handling specific container exit codes, e.g. `{ rules: [...] }`. |

### CronJob parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cronJob.schedule | string | `"0 * * * *"` | Cron schedule in standard cron format (tpl-rendered). |
| cronJob.timeZone | string | `""` | Time zone the schedule is interpreted in, e.g. Europe/Kyiv. Requires Kubernetes 1.27+. |
| cronJob.concurrencyPolicy | string | `""` | How to treat concurrent executions: Allow, Forbid or Replace. |
| cronJob.startingDeadlineSeconds | int | `nil` | Seconds by which a missed schedule may still be started. |
| cronJob.suspend | bool | `nil` | Suspend subsequent executions. |
| cronJob.successfulJobsHistoryLimit | int | `nil` | Number of successful finished Jobs to retain. |
| cronJob.failedJobsHistoryLimit | int | `nil` | Number of failed finished Jobs to retain. |

### Rollout parameters (`workload=rollout`)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| rollout.analysis | object | `{}` | Analysis run history limits, e.g. `{ successfulRunHistoryLimit: 5, unsuccessfulRunHistoryLimit: 5 }`. [Rollout Specification](https://argo-rollouts.readthedocs.io/en/stable/features/specification/) |
| rollout.minReadySeconds | int | `0` | Minimum seconds a new pod must be ready, with no container crashing, before it counts as available. 0 means available as soon as it is ready. |
| rollout.paused | bool | `nil` | Manually pause the rollout, halting its steps while HPA autoscaling continues. Normally set via tooling (`kubectl argo rollouts pause`) rather than here. If true at creation, replicas do not scale up from zero until manually promoted. |
| rollout.progressDeadlineSeconds | int | `600` | Seconds to wait for the rollout to make progress before reporting a failure. |
| rollout.progressDeadlineAbort | bool | `nil` | Whether to abort the update when progressDeadlineSeconds is exceeded. Defaults to false. |
| rollout.rollbackWindow | object | `{}` | Fast-track redeploys of a recently rolled-back revision, e.g. `{ revisions: 3 }`. Unset by default. |

### Security parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| serviceAccount.create | bool | `false` | Whether to create a ServiceAccount resource. |
| serviceAccount.annotations | object | `{}` | Annotations for the ServiceAccount. |
| serviceAccount.automount | bool | `nil` | Automatically mount API credentials. |
| serviceAccount.name | string | `""` | Name of the ServiceAccount. Auto-generated from fullname if empty and create=true. |
| rbac.create | bool | `false` | Whether to create a Role and RoleBinding for the ServiceAccount. |
| rbac.annotations | object | `{}` | Annotations for the Role and RoleBinding. |
| rbac.labels | object | `{}` | Labels for the Role and RoleBinding. |
| rbac.rules | list | `[]` | Policy rules for the Role (tpl-rendered), e.g. `[{ apiGroups: [""], resources: [pods], verbs: [get, list] }]`. |

### Network parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| service.enabled | bool | `false` | Whether to create a Service resource. |
| service.annotations | object | `{}` | Annotations for the Service. |
| service.type | string | `"ClusterIP"` | Service type. |
| service.port | int | `nil` | Primary port exposed by the Service (also used as the container's primary port). |
| service.targetPort | string | `"http"` | Target port on the container. Defaults to the port name "http". |
| service.protocol | string | `"TCP"` | Protocol for the primary port. |
| service.nodePort | string | `nil` | NodePort value (only applies to NodePort/LoadBalancer service types). |
| service.extraPorts | object | `{}` | Extra ports  Key is the port name. |
| service.headless | object | `{"annotations":{},"enabled":false,"labels":{},"publishNotReadyAddresses":true}` | Headless Service, exposing each pod under its own DNS name. Required for stable per-pod DNS with workload=statefulset. |
| ingress.enabled | bool | `false` | Whether to create an Ingress resource. |
| ingress.annotations | object | `{}` | Annotations for the Ingress. |
| ingress.className | string | `""` | Ingress class name. |
| ingress.hostnames | list | `[]` | List of hostnames to route traffic to this service. |
| ingress.paths | list | `[{"path":"/","pathType":"Prefix"}]` | Path rules applied to every hostname. |
| ingress.tls | object | `{"enabled":false,"secretName":""}` | TLS configuration. |
| ingress.tls.secretName | string | `""` | Secret name; defaults to "<first-hostname>-tls" when empty. |
| httpRoute.enabled | bool | `false` | Whether to create an HTTPRoute resource. |
| httpRoute.annotations | object | `{}` | Annotations for the HTTPRoute. |
| httpRoute.parentRefs | list | `[]` | Gateway parentRefs this route attaches to. |
| httpRoute.hostnames | list | `[]` | Hostnames matched by this route. |
| httpRoute.rules | list | `[{"matches":[{"path":{"type":"PathPrefix","value":"/"}}]}]` | Routing rules. backendRefs are auto-populated from the Service. |
| networkPolicy.enabled | bool | `false` | Whether to create a NetworkPolicy resource. |
| networkPolicy.annotations | object | `{}` | Annotations for the NetworkPolicy. |
| networkPolicy.labels | object | `{}` | Labels for the NetworkPolicy. |
| networkPolicy.podSelector | object | `{}` | Pods this policy applies to. Defaults to this release's selector labels when empty. |
| networkPolicy.policyTypes | list | `[]` | Policy types to enforce, e.g. [Ingress, Egress]. Listing a type without matching rules below denies all traffic of that type. |
| networkPolicy.ingress | list | `[]` | Ingress rules, passed through to the NetworkPolicy spec (tpl-rendered). |
| networkPolicy.egress | list | `[]` | Egress rules, passed through to the NetworkPolicy spec (tpl-rendered). |

### Horizontal Pod Autoscaling parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscaling.enabled | bool | `false` | Whether to create an HPA resource. Rejected with workload=daemonset, and with an active VPA (see vpa.updatePolicy). |
| autoscaling.annotations | object | `{}` | Annotations for the HPA. |
| autoscaling.labels | object | `{}` | Labels for the HPA. |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas when autoscaling is enabled. |
| autoscaling.maxReplicas | int | `10` | Maximum number of replicas when autoscaling is enabled. |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage. |
| autoscaling.behavior | object | `{}` | Advanced scaling behavior. |
| autoscaling.metrics | list | `[]` | Additional custom metrics (appended to the generated metrics list). |

### Vertical Pod Autoscaler parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| vpa.enabled | bool | `false` | Whether to create a VerticalPodAutoscaler resource. Requires the VPA controller in the cluster. |
| vpa.annotations | object | `{}` | Annotations for the VerticalPodAutoscaler. |
| vpa.labels | object | `{}` | Labels for the VerticalPodAutoscaler. |
| vpa.updatePolicy | object | `{"updateMode":"Off"}` | How the VPA applies its recommendations, e.g. `{ updateMode: Auto, minReplicas: 2 }`. Defaults to recommendation-only. Any mode other than `Off` is rejected when autoscaling.enabled=true, since both controllers would fight over the same pods. Note `Off` must stay quoted, or YAML parses it as false. |
| vpa.resourcePolicy | object | `{}` | Per-container bounds on the recommendation, e.g. `{ containerPolicies: [{ containerName: "*", minAllowed: { cpu: 10m } }] }`. |
| vpa.recommenders | object/list | `[]` | Alternative recommenders to use instead of the default one, e.g. `[{ name: custom-recommender }]`. |

### Pod Disruption Budget parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| podDisruptionBudget.enabled | bool | `false` | Whether to create a PodDisruptionBudget resource. |
| podDisruptionBudget.annotations | object | `{}` | Annotations for the PodDisruptionBudget. |
| podDisruptionBudget.labels | object | `{}` | Labels for the PodDisruptionBudget. |
| podDisruptionBudget.minAvailable | int/string | `1` | Minimum number or percentage of pods that must stay available. Mutually exclusive with maxUnavailable - set this to null to use maxUnavailable. |
| podDisruptionBudget.maxUnavailable | int/string | `nil` | Maximum number or percentage of pods that may be unavailable. Mutually exclusive with minAvailable. |
| podDisruptionBudget.unhealthyPodEvictionPolicy | string | `nil` | How unhealthy pods are counted during eviction: IfHealthyBudget or AlwaysAllow. |

### Storage parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.enabled | bool | `false` | Whether to create a PersistentVolumeClaim. |
| persistence.annotations | object | `{}` | Annotations for the PersistentVolumeClaim. |
| persistence.labels | object | `{}` | Labels for the PersistentVolumeClaim. |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Access modes for the volume. |
| persistence.size | string | `"8Gi"` | Requested size of the volume. |
| persistence.storageClassName | string | `""` | StorageClass to use. Empty uses the cluster default; set to "-" to disable dynamic provisioning. |
| persistence.volumeMode | string | `""` | Volume mode: Filesystem or Block. |
| persistence.volumeName | string | `""` | Bind to a specific PersistentVolume by name. |
| persistence.selector | object | `{}` | Label selector to bind an existing volume. |
| persistence.dataSource | object | `{}` | Source to populate the volume from, e.g. a snapshot. |

### ConfigMap parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMap.enabled | bool | `false` | Whether to create a ConfigMap resource. |
| configMap.annotations | object | `{}` | Annotations for the ConfigMap. |
| configMap.labels | object | `{}` | Labels for the ConfigMap. |
| configMap.data | object | `{}` | Key/value data for the ConfigMap. |

### Secret parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secret.enabled | bool | `false` | Whether to create a Secret resource. |
| secret.annotations | object | `{}` | Annotations for the Secret. |
| secret.labels | object | `{}` | Labels for the Secret. |
| secret.type | string | `"Opaque"` | Secret type. |
| secret.stringData | object | `{}` | Plaintext key/value pairs (tpl-rendered), encoded by Kubernetes. Prefer sourcing these from a secret manager at deploy time rather than committing them. |
| secret.data | object | `{}` | Pre-encoded base64 key/value pairs, passed through untouched. |

### Extras

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| extraObjects | object/list | `[]` | Render additional Kubernetes manifests. Each entry may be a string (with Go template expressions) or a YAML object. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
