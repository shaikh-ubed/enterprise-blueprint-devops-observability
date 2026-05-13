# 🚀 Phase 6: Deploy 3 Services Manually

## Overview
Deploy 3 custom microservices
manually to GKE cluster.
This demonstrates containerization
skills and dependency management!

## ⚙️ Prerequisites — Set Variables First!

```bash
export PROJECT_ID="YOUR_PROJECT_ID"
export REGISTRY="YOUR_REGISTRY"
```

## 💡 Why Deploy Manually First?
Manual deployment shows:
→ Understanding of K8s deployments ✅
→ Dependency management skills ✅
→ Debugging capabilities ✅
→ Production readiness knowledge ✅
Then Helm deployment shows:
→ Production deployment skills ✅
→ Package management knowledge ✅
→ Industry best practices ✅

## ✅ Correct Deploy Order
otel-collector  → telemetry first!
flagd ConfigMap → config before app!
flagd           → feature flags
PostgreSQL      → database
Verify all 3 dependencies running!
product-catalog → our Go service
ad-service      → our Java service
recommendation  → our Python service
Verify all 6 running! ✅

## 💻 Step 1: Deploy OTel Collector

```bash
kubectl apply -f k8s/dependencies/otel-collector.yaml
echo "✅ OTel Collector deployed!"
```

## 💻 Step 2: Create flagd ConfigMap

```bash
# Must create BEFORE flagd!
kubectl apply -f k8s/dependencies/flagd-configmap.yaml
echo "✅ flagd ConfigMap created!"
```

## 💻 Step 3: Deploy flagd

```bash
kubectl apply -f k8s/dependencies/flagd.yaml
echo "✅ flagd deployed!"
```

## 💻 Step 4: Deploy PostgreSQL

```bash
kubectl apply -f k8s/dependencies/postgres.yaml
echo "✅ PostgreSQL deployed!"
```

## ✅ Verify Dependencies Running

```bash
kubectl get pods -n otel-demo
# Expected:
# otel-collector  1/1  Running ✅
# flagd           1/1  Running ✅
# postgres        1/1  Running ✅
```

## 💻 Step 5: Deploy Product Catalog

```bash
kubectl apply -f k8s/services/product-catalog.yaml
echo "✅ Product Catalog deployed!"
```

## 💻 Step 6: Deploy Ad Service

```bash
kubectl apply -f k8s/services/ad-service.yaml
echo "✅ Ad Service deployed!"
```

## 💻 Step 7: Deploy Recommendation

```bash
kubectl apply -f k8s/services/recommendation.yaml
echo "✅ Recommendation deployed!"
```

## ✅ Verify ALL 6 Running

```bash
kubectl get pods -n otel-demo
# Expected:
# otel-collector  1/1  Running ✅
# flagd           1/1  Running ✅
# postgres        1/1  Running ✅
# product-catalog 1/1  Running ✅
# ad-service      1/1  Running ✅
# recommendation  1/1  Running ✅
```

## 🔍 Debugging Tips

```bash
# Check pod logs
kubectl logs -n otel-demo <pod-name>

# Check pod details
kubectl describe pod -n otel-demo <pod-name>

# ⚠️ NEVER exec into distroless!
# product-catalog has NO shell!
# Use kubectl logs instead!
```

## 🗑️ Delete All Before Helm

```bash
# Delete deployments
kubectl delete deployment \
  ad-service product-catalog \
  recommendation flagd postgres \
  otel-collector -n otel-demo

# Delete services
kubectl delete service \
  ad-service product-catalog \
  recommendation flagd postgres \
  otel-collector -n otel-demo

# ⚠️ Delete ConfigMap too!
kubectl delete configmap flagd-config \
  -n otel-demo

echo "✅ All deleted!"

# Verify clean
kubectl get pods -n otel-demo
# Expected: No resources found ✅
```

## ⚠️ Common Mistakes

| Mistake | Fix |
|---------|-----|
| Deploy without dependencies | Deploy deps first! |
| Deploy flagd without ConfigMap | Create ConfigMap first! |
| Exec into distroless | Use kubectl logs! |
| Forget to delete ConfigMap | Must delete before Helm! |
| Wrong deploy order | Follow exact order above! |

## 💡 Next Step
→ [Deploy via Helm](07-deploy-helm.md)
