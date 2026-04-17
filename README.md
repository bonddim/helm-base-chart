# Helm Base Chart

[![Last Commit](https://img.shields.io/github/last-commit/bonddim/helm-base-chart/main?style=flat-square)](https://github.com/bonddim/helm-base-chart/commits/main)
[![Latest Release](https://img.shields.io/github/v/release/bonddim/helm-base-chart?style=flat-square)](https://github.com/bonddim/helm-base-chart/releases)

A simple, straightforward Helm chart driven entirely by `values.yaml` for deploying standard Kubernetes resources - scaffolded from `helm create` and intentionally kept close to that structure so anyone can read, understand, and maintain it without prior knowledge of the chart.

## Usage

The chart is published to GitHub Container Registry as an OCI artifact. 
You may install it directly with your own values - **no wrapper chart, no boilerplate templates required**:

```bash
helm install my-release oci://ghcr.io/bonddim/helm-charts/base --values values.yaml
```

```bash
helm upgrade --install my-release oci://ghcr.io/bonddim/helm-charts/base --values values.yaml
```

A minimal `values.yaml` to get started:

```yaml
image:
  repository: my-app
  tag: "1.0.0"

service:
  enabled: true
  port: 8080

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: my-app.example.com
      paths:
        - path: /
          pathType: Prefix
```

See [chart/values.yaml](chart/values.yaml) and [chart/README.md](chart/README.md) for the full list of configurable parameters.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request with any improvements or bug fixes.
