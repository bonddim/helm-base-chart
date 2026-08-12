# base

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

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
| workload | string | `"deployment"` | Workload type to deploy. One of: deployment, daemonset, statefulset, rollout, pod or null |
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
| affinity | object | `{}` | Pod affinity/anti-affinity rules. |
| topologySpreadConstraints | list | `[]` | Topology spread constraints. |
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

### Security parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| serviceAccount.create | bool | `false` | Whether to create a ServiceAccount resource. |
| serviceAccount.annotations | object | `{}` | Annotations for the ServiceAccount. |
| serviceAccount.automount | bool | `nil` | Automatically mount API credentials. |
| serviceAccount.name | string | `""` | Name of the ServiceAccount. Auto-generated from fullname if empty and create=true. |

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
| httpRoute.rules | list | `[]` | Routing rules. backendRefs are auto-populated from the Service. |

### Autoscaling parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscaling.enabled | bool | `false` | Whether to create an HPA resource (also suppresses Deployment.spec.replicas). |
| autoscaling.annotations | object | `{}` | Annotations for the HPA. |
| autoscaling.labels | object | `{}` | Labels for the HPA. |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas when autoscaling is enabled. |
| autoscaling.maxReplicas | int | `10` | Maximum number of replicas when autoscaling is enabled. |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage. |
| autoscaling.behavior | object | `{}` | Advanced scaling behavior. |
| autoscaling.metrics | list | `[]` | Additional custom metrics (appended to the generated metrics list). |

### ConfigMap parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMap.enabled | bool | `false` | Whether to create a ConfigMap resource. |
| configMap.annotations | object | `{}` | Annotations for the ConfigMap. |
| configMap.labels | object | `{}` | Labels for the ConfigMap. |
| configMap.data | object | `{}` | Key/value data for the ConfigMap. |

### Extras

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| extraObjects | object/list | `[]` | Render additional Kubernetes manifests. Each entry may be a string (with Go template expressions) or a YAML object. |

### Other Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| rollout | object | `{"analysis":{},"minReadySeconds":0,"paused":null,"progressDeadlineAbort":null,"progressDeadlineSeconds":600,"rollbackWindow":{}}` | Rollout parameters. Only applicable when workload=rollout. https://argo-rollouts.readthedocs.io/en/stable/features/specification/ |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
