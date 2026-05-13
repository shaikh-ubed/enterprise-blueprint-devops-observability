#!/bin/bash
# ═══════════════════════════════════
# Script 1: Setup GCP Permissions
# Run this FIRST after VM creation!
# ═══════════════════════════════════

echo "Setting up GCP permissions..."

PROJECT_ID="deployandobserve"
SERVICE_ACCOUNT="YOUR_SERVICE_ACCOUNT"
GKE_NODE_SA="YOUR_GKE_NODE_SERVICE_ACCOUNT"

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
