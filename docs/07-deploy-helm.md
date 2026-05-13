# ⎈ Phase 7: Deploy All 16 via Helm

## Overview
Deploy complete OTel Demo with
all 16 microservices using Helm.
ONE command = ALL services! ✅

## ⚙️ Prerequisites — Set Variables First!

```bash
export PROJECT_ID="YOUR_PROJECT_ID"
```

## 💡 Why Helm?
Manual deployment:
→ 16 services × 3 files = 48 YAML files!
→ Complex dependency management!
→ Easy to miss something! ❌
Helm deployment:
→ ONE command = ALL 16 services! ✅
→ All dependencies handled! ✅
→ Production ready! ✅
→ Industry standard! ✅
## 📦 Install Helm

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version --short
# Expected: v3.20.x ✅
```

## 🚀 Deploy All 16 Services

```bash
# Add OTel Helm repo
helm repo add open-telemetry \
  https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update
echo "✅ Helm repo added!"

# Deploy all 16 services
helm install otel-demo \
  open-telemetry/opentelemetry-demo \
  --namespace otel-demo \
  --timeout 10m
echo "✅ OTel Demo deployed!"
```

## ✅ Verify All Pods Running

```bash
# Watch pods starting
kubectl get pods -n otel-demo -w

# Verify all running
kubectl get pods -n otel-demo
# Expected: ALL 27+ pods Running ✅

# ⚠️ Count all pods!
# If any missing = run helm upgrade!
helm upgrade otel-demo \
  open-telemetry/opentelemetry-demo \
  --namespace otel-demo \
  --timeout 10m
```

## 🌐 Access All Dashboards

```bash
# Patch to LoadBalancer
kubectl patch svc frontend-proxy \
  -n otel-demo \
  -p '{"spec": {"type": "LoadBalancer"}}'

kubectl patch svc prometheus \
  -n otel-demo \
  -p '{"spec": {"type": "LoadBalancer"}}'

echo "✅ Services patched!"

# Wait for External IPs
kubectl get svc frontend-proxy \
  -n otel-demo -w
# Press Ctrl+C when IP appears!

kubectl get svc prometheus \
  -n otel-demo -w
# Press Ctrl+C when IP appears!
```

## 📊 All Dashboard URLs

| Dashboard | URL | Login |
|-----------|-----|-------|
| 🛒 Webstore | http://FRONTEND-IP:8080/ | No login |
| 📊 Grafana | http://FRONTEND-IP:8080/grafana/ | admin/admin |
| 🔍 Jaeger | http://FRONTEND-IP:8080/jaeger/ui/ | No login |
| ⚡ Load Generator | http://FRONTEND-IP:8080/loadgen/ | No login |
| 🚩 Feature Flags | http://FRONTEND-IP:8080/feature/ | No login |
| 📈 Prometheus | http://PROMETHEUS-IP:9090 | No login |

## 🔥 Open Firewall Ports

```bash
# If not already opened!
gcloud compute firewall-rules create allow-8080 \
  --allow=tcp:8080 \
  --source-ranges=0.0.0.0/0 \
  --project=$PROJECT_ID

gcloud compute firewall-rules create allow-9090 \
  --allow=tcp:9090 \
  --source-ranges=0.0.0.0/0 \
  --project=$PROJECT_ID
```

## 16 Microservices Deployed

| Service | Language | Purpose |
|---------|----------|---------|
| frontend | TypeScript | Web UI |
| frontend-proxy | Envoy | API Gateway |
| product-catalog | Go | Products API |
| cart | .NET | Shopping cart |
| checkout | Go | Checkout flow |
| payment | Java | Payments |
| shipping | Rust | Shipping calc |
| email | Ruby | Email service |
| recommendation | Python | Recommendations |
| ad | Java | Advertisements |
| fraud-detection | Kotlin | Fraud detection |
| accounting | Go | Accounting |
| currency | C++ | Currency convert |
| image-provider | nginx | Image serving |
| load-generator | Python | Load testing |
| flagd | Go | Feature flags |

## ⚠️ Common Mistakes

| Mistake | Fix |
|---------|-----|
| Skip counting pods | Always count after install! |
| Forget ConfigMap delete | Delete before Helm install! |
| helm upgrade reverts LoadBalancer | Patch after every upgrade! |
| Forget firewall ports | Open 8080 AND 9090! |
| Try Prometheus via proxy | Prometheus needs own IP! |

## 💡 Next Step
→ [Observability](08-observability.md)
