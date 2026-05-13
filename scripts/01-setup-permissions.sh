#!/bin/bash
# ═══════════════════════════════════
# Script 1: Setup GCP Permissions
# Run this FIRST after VM creation!
# ═══════════════════════════════════

echo "Setting up GCP permissions..."

PROJECT_ID="deployandobserve"
SERVICE_ACCOUNT="918055665788-compute@developer.gserviceaccount.com"
GKE_NODE_SA="service-918055665788@gcp-sa-gkenode.iam.gserviceaccount.com"

# Editor role
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/editor"

# Artifact Registry Admin
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/artifactregistry.admin"

# Artifact Registry Reader
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/artifactregistry.reader"

# Container Admin
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/container.admin"

# Storage Admin (compute SA)
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/storage.admin"

# Storage Admin (GKE node SA)
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$GKE_NODE_SA" \
  --role="roles/storage.admin"

echo "✅ All permissions granted!"
