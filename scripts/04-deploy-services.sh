#!/bin/bash
# ═══════════════════════════════════
# Script 4: Deploy 3 Services
# Deploys dependencies first!
# Then deploys 3 custom services!
# Then deletes and deploys via Helm!
# ═══════════════════════════════════

echo "Starting deployment..."

# ─────────────────────────────────
# STEP 1: Deploy Dependencies First!
# ─────────────────────────────────
echo "Deploying dependencies..."

# Deploy OTel Collector
kubectl apply -f k8s/dependencies/otel-collector.yaml
echo "✅ OTel Collector deployed!"

# Deploy flagd ConfigMap first!
kubectl apply -f k8s/dependencies/flagd-configmap.yaml
echo "✅ flagd ConfigMap created!"

# Deploy flagd
kubectl apply -f k8s/dependencies/flagd.yaml
echo "✅ flagd deployed!"

# Deploy PostgreSQL
kubectl apply -f k8s/dependencies/postgres.yaml
echo "✅ PostgreSQL deployed!"

# Wait for dependencies
echo "Waiting for dependencies..."
sleep 30

# Verify dependencies running
kubectl get pods -n otel-demo

# ─────────────────────────────────
# STEP 2: Deploy 3 Custom Services!
# ─────────────────────────────────
echo "Deploying 3 custom services..."

kubectl apply -f k8s/services/product-catalog.yaml
echo "✅ Product Catalog deployed!"

kubectl apply -f k8s/services/ad-service.yaml
echo "✅ Ad Service deployed!"

kubectl apply -f k8s/services/recommendation.yaml
echo "✅ Recommendation deployed!"

# Wait for services
sleep 30

# Verify all 6 running
echo "Verifying all pods..."
kubectl get pods -n otel-demo

# ─────────────────────────────────
# STEP 3: Delete Manual Deployments
# ─────────────────────────────────
echo "Deleting manual deployments..."

kubectl delete -f k8s/services/
kubectl delete -f k8s/dependencies/

# Delete ConfigMap too!
kubectl delete configmap flagd-config \
  -n otel-demo

echo "✅ All manual deployments deleted!"

# Verify clean
kubectl get pods -n otel-demo

# ─────────────────────────────────
# STEP 4: Deploy All 16 via Helm!
# ─────────────────────────────────
echo "Deploying all 16 via Helm..."

helm repo add open-telemetry \
  https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update

helm install otel-demo \
  open-telemetry/opentelemetry-demo \
  --namespace otel-demo \
  --timeout 10m

echo "✅ All 16 services deployed!"

# Wait for pods
sleep 60

# Verify all pods
kubectl get pods -n otel-demo

# ─────────────────────────────────
# STEP 5: Expose Services
# ─────────────────────────────────
echo "Exposing services..."

kubectl patch svc frontend-proxy \
  -n otel-demo \
  -p '{"spec": {"type": "LoadBalancer"}}'

kubectl patch svc prometheus \
  -n otel-demo \
  -p '{"spec": {"type": "LoadBalancer"}}'

echo "✅ Services exposed!"

# Get External IPs
echo "Getting External IPs..."
kubectl get svc frontend-proxy -n otel-demo
kubectl get svc prometheus -n otel-demo

echo "✅ Deployment complete!"
echo "Open: http://EXTERNAL-IP:8080"
