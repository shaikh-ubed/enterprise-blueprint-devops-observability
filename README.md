# 🚀 Enterprise Blueprint — DevOps & Observability

![GCP](https://img.shields.io/badge/GCP-Cloud-blue?logo=googlecloud)
![Kubernetes](https://img.shields.io/badge/Kubernetes-GKE-326CE5?logo=kubernetes)
![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker)
![Helm](https://img.shields.io/badge/Helm-v3.20.2-0F1689?logo=helm)
![OpenTelemetry](https://img.shields.io/badge/OpenTelemetry-Observability-orange)
![Prometheus](https://img.shields.io/badge/Prometheus-Metrics-E6522C?logo=prometheus)
![Grafana](https://img.shields.io/badge/Grafana-Dashboards-F46800?logo=grafana)
![Velero](https://img.shields.io/badge/Velero-DR-green)

## 📋 Project Overview

Designed and implemented a production-grade
Enterprise DevOps & Observability blueprint
on GCP/GKE covering 16 microservices with
full observability stack (OTel, Prometheus,
Grafana, Jaeger), zero-trust security,
SLO-based reliability and automated DR
(RTO: 5min, RPO: 1hr).

> Based on [OpenTelemetry Demo](https://github.com/open-telemetry/opentelemetry-demo)

## 🏗️ Architecture

![Architecture](diagrams/architecture.png)

## 🎯 9 Engineering Roles Covered

| # | Role | What Was Built | Tools |
|---|------|----------------|-------|
| 1 | Developer | Custom Dockerfiles + K8s YAML | Docker, Go, Java, Python |
| 2 | DevOps Engineer | GKE + Helm + Deployments | GKE, Helm, Artifact Registry |
| 3 | Platform Engineer | Namespaces + Golden path | Helm, K8s |
| 4 | SRE | SLO + Error Budget + HPA | Prometheus, Grafana |
| 5 | Observability Engineer | OTel + Grafana + Jaeger | OpenTelemetry |
| 6 | Security Engineer | RBAC + Network Policy | K8s RBAC |
| 7 | DR Engineer | Velero + GCS backup | Velero, GCS |
| 8 | Cloud Architect | Design decisions | GCP |
| 9 | System Designer | Scale + HA + Databases | K8s, Kafka, PostgreSQL |

## 🔧 7 Technical Domains

| Domain | Implementation | Tools |
|--------|---------------|-------|
| 🔧 DevOps | Containerization + Deployment + IaC | Docker, GKE, Helm |
| 📊 Observability | OTel + Prometheus + Grafana + Jaeger | OpenTelemetry |
| ⚡ SRE | SLO + Error Budget + Auto-scaling | Prometheus, Grafana |
| 🔒 Security | RBAC + Network Policy + Image Scanning | K8s RBAC |
| 🔄 DR | Velero + GCS + RTO 5min + RPO 1hr | Velero |
| 🏗️ Architecture | GCP + GKE + Design decisions | GCP Console |
| 📐 System Design | 16 microservices + Kafka + PostgreSQL | K8s HPA |

## 💰 Cost Analysis

| Item | Our Cost | Commercial | Monthly Savings |
|------|----------|------------|----------------|
| GKE Cluster | $216/month | - | - |
| VM | $94/month | - | - |
| Storage | $10/month | - | - |
| Prometheus + Grafana | FREE | Datadog $2,000/month | $2,000 |
| Jaeger | FREE | Cloud Trace $800/month | $800 |
| Velero | FREE | Managed backup $500/month | $500 |
| Grafana Alerting | FREE | PagerDuty $500/month | $500 |
| **TOTAL** | **$320/month** | **$3,800+/month** | **$3,480/month** |
| **Annual Savings** | | | **$41,760/year** |

## 📈 SLO Targets

| Service | Language | Availability | Latency p99 | Error Rate |
|---------|----------|-------------|-------------|------------|
| Product Catalog | Go | 99.95% | < 100ms | < 0.5% |
| Ad Service | Java | 99.9% | < 200ms | < 1% |
| Recommendation | Python | 99.9% | < 500ms | < 1% |
| Overall Platform | - | 99.9% | < 500ms | < 1% |

## 🚀 Quick Start

### Prerequisites
```bash
gcloud CLI
kubectl v1.28.15
Helm v3.20.2
Docker v29.4.3
GKE Auth Plugin v35.0.1
```

### Phase 1: Create VM
```bash
gcloud compute instances create otel \
  --zone=us-central1-a \
  --machine-type=e2-standard-4 \
  --image-family=ubuntu-2404-lts \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=100GB \
  --boot-disk-type=pd-standard \
  --tags=http-server,https-server \
  --project=YOUR_PROJECT_ID
```

### Phase 2: Build 3 Custom Docker Images
```bash
# Product Catalog (Go)
docker build \
  -t $REGISTRY/product-catalog:v1 \
  -f src/product-catalog/Dockerfile \
  --build-arg GOPROXY=direct \
  .

# Ad Service (Java) — build-arg mandatory!
docker build \
  -t $REGISTRY/ad-service:v1 \
  -f src/ad/Dockerfile \
  --build-arg OTEL_JAVA_AGENT_VERSION=2.12.0 \
  .

# Recommendation (Python)
docker build \
  -t $REGISTRY/recommendation:v1 \
  -f src/recommendation/Dockerfile \
  .
```

### Phase 3: Create GKE Cluster
```bash
gcloud container clusters create otel-demo-cluster \
  --zone=us-central1-a \
  --num-nodes=3 \
  --machine-type=e2-standard-4 \
  --enable-network-policy \
  --workload-pool=YOUR_PROJECT_ID.svc.id.goog \
  --maintenance-window="03:00" \
  --disk-size=50GB \
  --disk-type=pd-standard \
  --project=YOUR_PROJECT_ID
```

### Phase 4: Deploy 3 Services Manually
```bash
# Deploy dependencies first!
kubectl apply -f k8s/dependencies/

# Verify dependencies running
kubectl get pods -n otel-demo

# Deploy our 3 custom services
kubectl apply -f k8s/services/

# Verify all 6 running
kubectl get pods -n otel-demo
```

### Phase 5: Delete + Deploy via Helm
```bash
# Delete manual deployments
kubectl delete -f k8s/services/
kubectl delete -f k8s/dependencies/
kubectl delete configmap flagd-config -n otel-demo

# Deploy all 16 via Helm
helm repo add open-telemetry \
  https://open-telemetry.github.io/opentelemetry-helm-charts
helm install otel-demo \
  open-telemetry/opentelemetry-demo \
  --namespace otel-demo \
  --timeout 10m

# Verify all pods running
kubectl get pods -n otel-demo
```

### Phase 6: Access Dashboards
```bash
# Patch to LoadBalancer
kubectl patch svc frontend-proxy \
  -n otel-demo \
  -p '{"spec": {"type": "LoadBalancer"}}'

kubectl patch svc prometheus \
  -n otel-demo \
  -p '{"spec": {"type": "LoadBalancer"}}'

# Get External IPs
kubectl get svc frontend-proxy -n otel-demo
kubectl get svc prometheus -n otel-demo
```

## 📊 Dashboards

| Dashboard | URL | Login |
|-----------|-----|-------|
| 🛒 Webstore | http://EXTERNAL-IP:8080/ | No login |
| 📊 Grafana | http://EXTERNAL-IP:8080/grafana/ | admin/admin |
| 🔍 Jaeger | http://EXTERNAL-IP:8080/jaeger/ui/ | No login |
| ⚡ Load Generator | http://EXTERNAL-IP:8080/loadgen/ | No login |
| 🚩 Feature Flags | http://EXTERNAL-IP:8080/feature/ | No login |
| 📈 Prometheus | http://PROMETHEUS-IP:9090 | No login |

## 🔒 Security Implementation

```bash
# Create RBAC roles
kubectl create role developer \
  --verb=get,list,watch,create,update,patch \
  --resource=pods,deployments,services \
  --namespace=otel-demo

kubectl create role viewer \
  --verb=get,list,watch \
  --resource=pods,services,deployments \
  --namespace=otel-demo

# Network Policy (zero trust!)
kubectl apply -f k8s/security/network-policy.yaml
```

## 🔄 Disaster Recovery

```bash
# Install Velero
helm install velero vmware-tanzu/velero \
  --namespace velero \
  --create-namespace \
  --set configuration.backupStorageLocation[0].provider=gcp \
  --set configuration.backupStorageLocation[0].bucket=YOUR_BUCKET

# Create backup
velero backup create otel-backup-v1 \
  --include-namespaces otel-demo \
  --wait

# Schedule backup every 6 hours
velero schedule create otel-schedule \
  --schedule="0 */6 * * *" \
  --include-namespaces otel-demo
```

## 📸 Screenshots

### 🛒 Webstore Running
![Webstore](screenshots/webstore.png)

### 📊 Grafana Dashboard
![Grafana](screenshots/grafana.png)

### 🔍 Jaeger Traces
![Jaeger](screenshots/jaeger.png)

### ✅ All Pods Running
![Pods](screenshots/pods.png)

### 🔄 Velero Backup
![Velero](screenshots/velero.png)

### 🏗️ GKE Cluster
![GKE](screenshots/gke-cluster.png)

## 🛠️ Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| Cloud | Google Cloud Platform | - |
| Container | Docker | 29.4.3 |
| Orchestration | Kubernetes (GKE) | 1.35.3 |
| Package Manager | Helm | 3.20.2 |
| Observability | OpenTelemetry | Latest |
| Metrics | Prometheus | Latest |
| Visualization | Grafana | Latest |
| Tracing | Jaeger | Latest |
| Security | K8s RBAC + Network Policy | - |
| DR | Velero | 1.18.0 |
| Registry | Artifact Registry | - |
| Database | PostgreSQL | 16 |
| Message Queue | Kafka | Latest |

## 📁 Repository Structure

```
enterprise-blueprint-devops-observability/
│
├── README.md
├── diagrams/
│   └── architecture.png
├── screenshots/
│   ├── webstore.png
│   ├── grafana.png
│   ├── jaeger.png
│   ├── pods.png
│   └── velero.png
├── k8s/
│   ├── dependencies/
│   │   ├── otel-collector.yaml
│   │   ├── flagd-configmap.yaml
│   │   ├── flagd.yaml
│   │   └── postgres.yaml
│   ├── services/
│   │   ├── product-catalog.yaml
│   │   ├── ad-service.yaml
│   │   └── recommendation.yaml
│   └── security/
│       ├── rbac.yaml
│       └── network-policy.yaml
├── docs/
│   ├── 01-vm-setup.md
│   ├── 02-tools-installation.md
│   ├── 03-gcp-setup.md
│   ├── 04-docker-images.md
│   ├── 05-gke-cluster.md
│   ├── 06-deploy-3-services.md
│   ├── 07-deploy-helm.md
│   ├── 08-observability.md
│   ├── 09-security.md
│   └── 10-disaster-recovery.md
└── scripts/
    ├── 01-setup-permissions.sh
    ├── 02-create-cluster.sh
    ├── 03-build-push-images.sh
    ├── 04-deploy-services.sh
    └── 05-setup-velero.sh
```

## 👤 Author

**Shaikh Ubed**
DevOps Engineer

[![GitHub](https://img.shields.io/badge/GitHub-shaikh--ubed-black?logo=github)](https://github.com/shaikh-ubed)

## 📄 License

MIT License — feel free to use this
as a reference for your own projects!
