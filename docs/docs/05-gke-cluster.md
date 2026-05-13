# ⚙️ Phase 5: GKE Cluster

## Overview
Create and configure GKE cluster
with all best practices!

## ⚙️ Prerequisites — Set Variables First!

```bash
export PROJECT_ID="YOUR_PROJECT_ID"
export ZONE="YOUR_ZONE"
export SERVICE_ACCOUNT="YOUR_SERVICE_ACCOUNT"
```

## 📋 Cluster Configuration

| Setting | Value |
|---------|-------|
| Name | otel-demo-cluster |
| Zone | YOUR_ZONE |
| Nodes | 3 x e2-standard-4 |
| vCPU per node | 4 |
| RAM per node | 16GB |
| Disk type | pd-standard |
| Disk size | 50GB |
| Network policy | Enabled ✅ |
| Workload Identity | Enabled ✅ |
| Maintenance window | 03:00 |

## 📱 Manual Way

console.cloud.google.com
→ Kubernetes Engine → Clusters
→ CREATE → STANDARD cluster
→ Name: otel-demo-cluster
→ Zone: YOUR_ZONE
→ Nodes: 3 x e2-standard-4
→ Disk type: Standard persistent disk
→ Disk size: 50GB
→ Enable network policy: ✅
→ Click CREATE → wait 5-8 min

## 💻 CLI Way

```bash
gcloud container clusters create otel-demo-cluster \
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
```

## 🔗 Connect kubectl

```bash
gcloud container clusters get-credentials \
  otel-demo-cluster \
  --zone=$ZONE \
  --project=$PROJECT_ID
echo "✅ kubectl connected!"

# Verify nodes
kubectl get nodes
# Expected: 3 nodes STATUS = Ready ✅
```

## 🔑 Bind Workload Identity

💡 Must do BEFORE installing Velero!

```bash
gcloud iam service-accounts \
  add-iam-policy-binding \
  $SERVICE_ACCOUNT \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:$PROJECT_ID.svc.id.goog[velero/velero-server]"
echo "✅ Workload Identity bound!"
```

## 📦 Create Namespaces

```bash
# CLI only — no manual way!
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

# Verify
kubectl get namespaces --show-labels
```

## ✅ Health Check

```bash
# Check cluster status
gcloud container clusters list \
  --project=$PROJECT_ID
# Expected: STATUS = RUNNING ✅

# Check nodes
kubectl get nodes
# Expected: 3 nodes Ready ✅

# Check namespaces
kubectl get namespaces --show-labels
```

## ⚠️ Common Mistakes

| Mistake | Fix |
|---------|-----|
| Forget GKE Auth Plugin | Install before cluster! |
| Use default SSD disk | Always pd-standard! |
| SSH disconnecting | Use Browser SSH! |
| Missing network policy | Add --enable-network-policy! |
| Wrong zone | Check availability first! |
| SSD quota exceeded | Use pd-standard 50GB! |

## 💡 Next Step
→ [Deploy 3 Services](06-deploy-3-services.md)
