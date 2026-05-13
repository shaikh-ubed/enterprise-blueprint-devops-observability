# 🐳 Phase 4: Docker Images

## Overview
Build and push 3 custom Docker
images to GCP Artifact Registry.

## ⚙️ Prerequisites — Set Variables First!

```bash
export PROJECT_ID="YOUR_PROJECT_ID"
export REGISTRY="us-central1-docker.pkg.dev/$PROJECT_ID/otel-demo"
```

## 3 Custom Microservices

| Service | Language | Port | Image Size |
|---------|----------|------|------------|
| product-catalog | Go | 3550 | ~8.5MB |
| ad-service | Java | 9555 | ~188MB |
| recommendation | Python | 9001 | ~34MB |

## 📖 Read Dockerfiles First!

```bash
# Always read before building!
cat src/product-catalog/Dockerfile
cat src/ad/Dockerfile
cat src/recommendation/Dockerfile
```

## 🔑 Key Dockerfile Facts

### Product Catalog (Go)

Base:    golang:1.25-bookworm
Final:   gcr.io/distroless/static-debian12:nonroot
Context: repo root (.)
Arg:     GOPROXY=direct (fixes network!)
Shell:   NO shell (distroless!)
Use kubectl logs to debug!


### Ad Service (Java)

Base:    eclipse-temurin:21-jdk
Final:   eclipse-temurin:21-jre
Context: repo root (.)
Arg:     OTEL_JAVA_AGENT_VERSION=2.12.0
MANDATORY! Without it = FAIL!
Shell:   YES ✅


### Recommendation (Python)

Base:    python:3.14-alpine3.23
Context: repo root (.)
Arg:     None needed
Shell:   YES ✅
OTel:    auto-instrumented via
opentelemetry-instrument

## 💻 Build Commands

```bash
# Must be in repo root!
cd ~/opentelemetry-demo

# Product Catalog (Go) ~2-3 min
docker build \
  -t $REGISTRY/product-catalog:v1 \
  -f src/product-catalog/Dockerfile \
  --build-arg GOPROXY=direct \
  .
echo "✅ Product Catalog built!"

# Ad Service (Java) ~8-10 min
# ⚠️ --build-arg MANDATORY!
docker build \
  -t $REGISTRY/ad-service:v1 \
  -f src/ad/Dockerfile \
  --build-arg OTEL_JAVA_AGENT_VERSION=2.12.0 \
  .
echo "✅ Ad Service built!"

# Recommendation (Python) ~3-4 min
docker build \
  -t $REGISTRY/recommendation:v1 \
  -f src/recommendation/Dockerfile \
  .
echo "✅ Recommendation built!"
```

## 💻 Push Commands

```bash
# Always push from VM!
# Never push from Cloud Shell!
docker push $REGISTRY/product-catalog:v1
echo "✅ Product Catalog pushed!"

docker push $REGISTRY/ad-service:v1
echo "✅ Ad Service pushed!"

docker push $REGISTRY/recommendation:v1
echo "✅ Recommendation pushed!"
```

## ✅ Verify in Registry

### 📱 Manual Way

console.cloud.google.com
→ Artifact Registry
→ otel-demo repository
→ See 3 images listed ✅

### 💻 CLI Way
```bash
gcloud artifacts docker images list \
  us-central1-docker.pkg.dev/$PROJECT_ID/otel-demo \
  --project=$PROJECT_ID
# Expected: 3 images listed ✅
```

## ⚠️ Common Mistakes

| Mistake | Fix |
|---------|-----|
| Build in Cloud Shell | Always build in VM! |
| Wrong build context | Always use . (repo root!) |
| Missing --build-arg for Java | MANDATORY! Always add! |
| Missing GOPROXY for Go | Add --build-arg GOPROXY=direct |
| Push from Cloud Shell | Always push from VM! |
| Registry not created first | Create registry before pushing! |

## 💡 Next Step
→ [GKE Cluster](05-gke-cluster.md)
