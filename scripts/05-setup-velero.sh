#!/bin/bash
# ═══════════════════════════════════
# Script 5: Setup Disaster Recovery
# Installs Velero + creates backups!
# Run after cluster is created!
# ═══════════════════════════════════

echo "Setting up Disaster Recovery..."

PROJECT_ID="deployandobserve"
BUCKET_NAME="otel-demo-velero-backups"
SERVICE_ACCOUNT="918055665788-compute@developer.gserviceaccount.com"

# ─────────────────────────────────
# STEP 1: Create GCS Bucket
# ─────────────────────────────────
echo "Creating GCS bucket..."

gsutil mb -l us-central1 \
  gs://$BUCKET_NAME

echo "✅ GCS Bucket created!"

# ─────────────────────────────────
# STEP 2: Add Velero Helm Repo
# ─────────────────────────────────
echo "Adding Velero Helm repo..."

helm repo add vmware-tanzu \
  https://vmware-tanzu.github.io/helm-charts
helm repo update

echo "✅ Velero repo added!"

# ─────────────────────────────────
# STEP 3: Install Velero
# ─────────────────────────────────
echo "Installing Velero..."

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

# ─────────────────────────────────
# STEP 4: Annotate velero-server SA
# ─────────────────────────────────
echo "Annotating velero-server SA..."

kubectl annotate serviceaccount velero-server \
  -n velero \
  iam.gke.io/gcp-service-account=$SERVICE_ACCOUNT

echo "✅ SA annotated!"

# ─────────────────────────────────
# STEP 5: Install Velero CLI
# ─────────────────────────────────
echo "Installing Velero CLI..."

wget https://github.com/vmware-tanzu/velero/releases/download/v1.18.0/velero-v1.18.0-linux-amd64.tar.gz
tar -xvf velero-v1.18.0-linux-amd64.tar.gz
sudo mv velero-v1.18.0-linux-amd64/velero \
  /usr/local/bin/

echo "✅ Velero CLI installed!"

# ─────────────────────────────────
# STEP 6: Restart Velero
# ─────────────────────────────────
echo "Restarting Velero..."

kubectl rollout restart deployment/velero \
  -n velero

echo "✅ Velero restarted!"

# Wait for Velero
echo "Waiting for Velero..."
sleep 60

# ─────────────────────────────────
# STEP 7: Verify Backup Location
# ─────────────────────────────────
echo "Verifying backup location..."

velero backup-location get
# Expected: PHASE = Available ✅

# ─────────────────────────────────
# STEP 8: Create First Backup
# ─────────────────────────────────
echo "Creating first backup..."

velero backup create otel-backup-v1 \
  --include-namespaces otel-demo \
  --wait

echo "✅ First backup created!"

# ─────────────────────────────────
# STEP 9: Create Schedule
# ─────────────────────────────────
echo "Creating backup schedule..."

velero schedule create otel-schedule \
  --schedule="0 */6 * * *" \
  --include-namespaces otel-demo

echo "✅ Schedule created!"

# Verify everything
velero backup get
velero schedule get

echo "✅ Disaster Recovery setup complete!"
echo "RTO: 5 minutes | RPO: 1 hour"
