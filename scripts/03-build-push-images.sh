#!/bin/bash
# ═══════════════════════════════════
# Script 3: Build & Push 3 Images
# Run from repo root directory!
# ═══════════════════════════════════

echo "Starting build and push..."

PROJECT_ID="deployandobserve"
REGISTRY="us-central1-docker.pkg.dev/$PROJECT_ID/otel-demo"

# Configure Docker for GCP
gcloud auth configure-docker \
  us-central1-docker.pkg.dev

echo "✅ Docker configured!"

# Create Artifact Registry
gcloud artifacts repositories create otel-demo \
  --repository-format=docker \
  --location=us-central1 \
  --project=$PROJECT_ID

echo "✅ Registry created!"

# Build Product Catalog (Go)
# GOPROXY=direct fixes network issue!
echo "Building product-catalog..."
docker build \
  -t $REGISTRY/product-catalog:v1 \
  -f src/product-catalog/Dockerfile \
  --build-arg GOPROXY=direct \
  .
echo "✅ Product Catalog built!"

# Build Ad Service (Java)
# --build-arg MANDATORY for Java!
echo "Building ad-service..."
docker build \
  -t $REGISTRY/ad-service:v1 \
  -f src/ad/Dockerfile \
  --build-arg OTEL_JAVA_AGENT_VERSION=2.12.0 \
  .
echo "✅ Ad Service built!"

# Build Recommendation (Python)
echo "Building recommendation..."
docker build \
  -t $REGISTRY/recommendation:v1 \
  -f src/recommendation/Dockerfile \
  .
echo "✅ Recommendation built!"

# Push all 3 images
echo "Pushing images..."
docker push $REGISTRY/product-catalog:v1
echo "✅ Product Catalog pushed!"

docker push $REGISTRY/ad-service:v1
echo "✅ Ad Service pushed!"

docker push $REGISTRY/recommendation:v1
echo "✅ Recommendation pushed!"

# Verify all 3 in registry
echo "Verifying images..."
gcloud artifacts docker images list \
  us-central1-docker.pkg.dev/$PROJECT_ID/otel-demo \
  --project=$PROJECT_ID

echo "✅ All images built and pushed!"
