# 📊 Phase 8: Observability

## Overview
Full observability stack using
OpenTelemetry, Prometheus,
Grafana and Jaeger.

## 💡 3 Pillars of Observability
Metrics  → Prometheus + Grafana
Traces   → Jaeger
Logs     → OpenSearch + OTel Collector

## 🔭 OpenTelemetry Stack
OTel Collector (DaemonSet)
→ Receives: Traces + Metrics + Logs
→ Port: 4317 (gRPC)
→ Exports to:
→ Prometheus (metrics)
→ Jaeger (traces)
→ OpenSearch (logs)

## 📊 Grafana Dashboards

| Dashboard | Purpose |
|-----------|---------|
| Demo Dashboard | RED metrics overview |
| APM Dashboard | Jaeger + Prometheus |
| OpenTelemetry Collector | OTel pipeline |
| PostgreSQL | Database metrics |
| Linux | Host metrics |
| Spanmetrics | Span analysis |
| Cart Service Exemplars | Cart traces |
| NGINX Metrics | Image provider |

## 🔍 Jaeger Tracing
Access Jaeger:
→ http://FRONTEND-IP:8080/jaeger/ui/
Features:
→ Distributed trace search
→ Service dependency map
→ Latency analysis
→ Error detection
→ Root cause analysis

## 📐 SLO Targets

| Service | Availability | Latency p99 |
|---------|-------------|-------------|
| Product Catalog | 99.95% | < 100ms |
| Ad Service | 99.9% | < 200ms |
| Recommendation | 99.9% | < 500ms |
| Overall Platform | 99.9% | < 500ms |

## 📐 SLO Queries

### Availability SLO
```promql
(
  sum(rate(http_server_duration_milliseconds_count{
    http_status_code!~"5.."
  }[5m]))
  /
  sum(rate(http_server_duration_milliseconds_count[5m]))
) * 100
```

### Error Budget Remaining
```promql
100 - (
  sum(rate(http_server_duration_milliseconds_count{
    http_status_code=~"5.."
  }[5m]))
  /
  sum(rate(http_server_duration_milliseconds_count[5m]))
  * 100
)
```

## 🌐 Access Observability Stack

| Tool | URL | Login |
|------|-----|-------|
| Grafana | http://FRONTEND-IP:8080/grafana/ | admin/admin |
| Jaeger | http://FRONTEND-IP:8080/jaeger/ui/ | No login |
| Prometheus | http://PROMETHEUS-IP:9090 | No login |

## ⚠️ Common Mistakes

| Mistake | Fix |
|---------|-----|
| Prometheus 404 via proxy | Use own LoadBalancer! |
| No data in Grafana | Wait 5 min after deploy! |
| Jaeger no traces | Load generator must run! |

## 💡 Next Step
→ [Security](09-security.md)
