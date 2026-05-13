#!/bin/bash
# ═══════════════════════════════════
# Script 2: Create GKE Cluster
# Run after 01-setup-permissions.sh!
# ═══════════════════════════════════

echo "Creating GKE cluster..."

PROJECT_ID="deployandobserve"
CLUSTER_NAME="otel-demo-cluster"
ZONE="us-central1-a"

# Create GKE cluster
# pd-standard = no SSD quota issue!
gcloud container clusters create $CLUSTER_NAME \
  --zone=$ZONE \
  --num-nodes=3 \
  --machine-type=e2-standard-4 \
  --enable-network-policy \
  --workload-pool=$PROJECT_ID.svc.id.goog \
  --maintenance-window="03:00" \
  --disk-size=50GB \
  --disk-type=pd-standard \
  --project=$PROJECT_ID

echo "✅ Cluster created!"

# Connect kubectl
gcloud container clusters get-credentials \
  $CLUSTER_NAME \
  --zone=$ZONE \
  --project=$PROJECT_ID

echo "✅ kubectl connected!"

# Verify nodes
kubectl get nodes

# Bind Workload Identity for Velero
gcloud iam service-accounts \
  add-iam-policy-binding \
  918055665788-compute@developer.gserviceaccount.com \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:$PROJECT_ID.svc.id.goog[velero/velero-server]"

echo "✅ Workload Identity bound!"

# Open firewall ports
gcloud compute firewall-rules create allow-8080 \
  --allow=tcp:8080 \
  --source-ranges=0.0.0.0/0 \
  --project=$PROJECT_ID

gcloud compute firewall-rules create allow-9090 \
  --allow=tcp:9090 \
  --source-ranges=0.0.0.0/0 \
  --project=$PROJECT_ID

echo "✅ Firewall ports opened!"

# Create namespaces
kubectl create namespace otel-demo
kubectl create namespace observability
kubectl create namespace monitoring

# Add labels
kubectl label namespace otel-demo \
  environment=production team=platform
kubectl label namespace observability \
  environment=production team=sre
kubectl label namespace monitoring \
  environment=production team=sre

echo "✅ Namespaces created!"
echo "✅ Cluster setup complete!"
