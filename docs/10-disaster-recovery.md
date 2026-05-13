# 🔄 Phase 10: Disaster Recovery

## Overview
Automated disaster recovery using
Velero with GCS bucket storage.
RTO: 5 minutes | RPO: 1 hour

## ⚙️ Prerequisites — Set Variables First!

```bash
export PROJECT_ID="YOUR_PROJECT_ID"
export SERVICE_ACCOUNT="YOUR_SERVICE_ACCOUNT"
export BUCKET_NAME="otel-demo-velero-backups"
```

## 💡 DR Targets

| Metric | Target | Meaning |
|--------|--------|---------|
| RTO | 5 minutes | Time to recover |
| RPO | 1 hour | Max data loss |
| Availability | 99.9% | Uptime target |
| Error Budget | 43 min/month | Allowed downtime |

## 🗄️ Create GCS Bucket

### 📱 Manual Way
console.cloud.google.com
→ Cloud Storage → Buckets
→ CREATE BUCKET
→ Name: otel-demo-velero-backups
→ Region: us-central1
→ Click CREATE

### 💻 CLI Way
```bash
gsutil mb -l us-central1 \
  gs://$BUCKET_NAME
echo "✅ GCS Bucket created!"

# Verify
gsutil ls
# Expected: gs://otel-demo-velero-backups/ ✅
```

## ⎈ Install Velero

### Add Helm Repo
```bash
helm repo add vmware-tanzu \
  https://vmware-tanzu.github.io/helm-charts
helm repo update
echo "✅ Velero repo added!"
```

### Install Velero
```bash
# ⚠️ NO region in config!
# ⚠️ Add serviceAccount in config!
helm install velero vmware-tanzu/velero \
  --namespace velero \
  --create-namespace \
  --set configuration.backupStorageLocation[0].name=default \
  --set configuration.backupStorageLocation[0].provider=gcp \
  --set configuration.backupStorageLocation[0].bucket=$BUCKET_NAME \
  --set configuration.backupStorageLocation[0].config.serviceAccount=$SERVICE_ACCOUNT \
  --set configuration.volumeSnapshotLocation[0].name=default \
  --set configuration.volumeSnapshotLocation[0].provider=gcp \
  --set credentials.useSecret=false \
  --set initContainers[0].name=velero-plugin-for-gcp \
  --set initContainers[0].image=velero/velero-plugin-for-gcp:v1.9.0 \
  --set initContainers[0].volumeMounts[0].mountPath=/target \
  --set initContainers[0].volumeMounts[0].name=plugins
echo "✅ Velero installed!"
```

## 🔑 Annotate velero-server SA

```bash
# Check SA name first!
kubectl get serviceaccount -n velero
# Expected: velero-server ✅

# Annotate SA
kubectl annotate serviceaccount velero-server \
  -n velero \
  iam.gke.io/gcp-service-account=$SERVICE_ACCOUNT
echo "✅ SA annotated!"

# Restart Velero
kubectl rollout restart deployment/velero \
  -n velero
echo "✅ Velero restarted!"
```

## 💻 Install Velero CLI

```bash
wget https://github.com/vmware-tanzu/velero/releases/download/v1.18.0/velero-v1.18.0-linux-amd64.tar.gz
tar -xvf velero-v1.18.0-linux-amd64.tar.gz
sudo mv velero-v1.18.0-linux-amd64/velero \
  /usr/local/bin/
velero version
echo "✅ Velero CLI installed!"
```

## ✅ Verify Backup Location

```bash
sleep 60 && velero backup-location get
# Expected: PHASE = Available ✅
```

## 💾 Create First Backup

```bash
# Check existing backups first!
velero backup get

# Create backup
velero backup create otel-backup-v1 \
  --include-namespaces otel-demo \
  --wait
echo "✅ First backup done!"

# Verify
velero backup get
# Expected: STATUS = Completed ✅

# Verify in GCS
gsutil ls gs://$BUCKET_NAME/
# Expected: backups/ folder ✅
```

## ⏰ Schedule Automatic Backups

```bash
# Backup every 6 hours!
velero schedule create otel-schedule \
  --schedule="0 */6 * * *" \
  --include-namespaces otel-demo
echo "✅ Schedule created!"

# Verify schedule
velero schedule get
# Expected: STATUS = Enabled ✅
```

## 🔄 Test Restore

```bash
# Simulate disaster!
kubectl delete namespace otel-demo

# Restore from backup
velero restore create \
  --from-backup otel-backup-v1 \
  --wait
echo "✅ Restore done!"

# Verify restore
kubectl get pods -n otel-demo
# Expected: all pods Running ✅
```

## 📊 DR Architecture
GKE Cluster (primary)
→ Velero (backup every 6 hours)
→ Google Cloud Storage
→ DR Cluster (standby)
→ Restore in 5 minutes!

## ⚠️ Common Mistakes

| Mistake | Fix |
|---------|-----|
| Add region in config | GCP plugin rejects it! |
| Wrong SA name | Helm creates velero-server! |
| Skip annotation | Annotation is mandatory! |
| Same backup name twice | Check existing first! |
| Skip restart after changes | Always restart Velero! |

## 🎉 Project Complete!
✅ DevOps       → Docker + GKE + Helm
✅ Observability → OTel + Grafana + Jaeger
✅ SRE          → SLO + Error Budget
✅ Security     → RBAC + Network Policy
✅ DR           → Velero + GCS backup
✅ Architecture → GCP + GKE design
✅ System Design→ 16 microservices
