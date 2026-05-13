# ☁️ Phase 3: GCP Setup

## Overview
Configure GCP permissions,
Artifact Registry and Docker
for the project.

## ⚙️ Prerequisites — Set Variables First!

```bash
export PROJECT_ID="YOUR_PROJECT_ID"
export SERVICE_ACCOUNT="YOUR_SERVICE_ACCOUNT"
export GKE_NODE_SA="YOUR_GKE_NODE_SERVICE_ACCOUNT"
```

## 📋 Give ALL Permissions at Once!

💡 Do immediately after first login!
💡 No permission errors anywhere after!

```bash
# Editor
gcloud projects add-iam-policy-binding \
  $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/editor"

# Artifact Registry Admin
gcloud projects add-iam-policy-binding \
  $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/artifactregistry.admin"

# Artifact Registry Reader
gcloud projects add-iam-policy-binding \
  $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/artifactregistry.reader"

# Container Admin
gcloud projects add-iam-policy-binding \
  $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/container.admin"

# Storage Admin (compute SA)
gcloud projects add-iam-policy-binding \
  $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/storage.admin"

# Storage Admin (GKE node SA)
gcloud projects add-iam-policy-binding \
  $PROJECT_ID \
  --member="serviceAccount:$GKE_NODE_SA" \
  --role="roles/storage.admin"

echo "✅ ALL permissions granted!"
```

## ✅ Verify Permissions

```bash
gcloud projects get-iam-policy $PROJECT_ID \
  --flatten="bindings[].members" \
  --format="table(bindings.role,bindings.members)" \
  --filter="bindings.members:$SERVICE_ACCOUNT"
```

## 🗄️ Create Artifact Registry

### 📱 Manual Way

console.cloud.google.com
→ Artifact Registry
→ Repositories
→ CREATE REPOSITORY
→ Name:   otel-demo
→ Format: Docker
→ Region: us-central1
→ Click CREATE

### 💻 CLI Way
```bash
gcloud artifacts repositories create otel-demo \
  --repository-format=docker \
  --location=us-central1 \
  --project=$PROJECT_ID
echo "✅ Registry created!"
```

### Verify Registry
```bash
gcloud artifacts repositories list \
  --project=$PROJECT_ID
# Expected: otel-demo DOCKER us-central1 ✅
```

## 🐳 Configure Docker for GCP

```bash
gcloud auth configure-docker \
  us-central1-docker.pkg.dev
# Answer: Y
echo "✅ Docker configured!"
```

## 🔥 Open Firewall Ports

### 📱 Manual Way

### 💻 CLI Way
```bash
gcloud artifacts repositories create otel-demo \
  --repository-format=docker \
  --location=us-central1 \
  --project=$PROJECT_ID
echo "✅ Registry created!"
```

### Verify Registry
```bash
gcloud artifacts repositories list \
  --project=$PROJECT_ID
# Expected: otel-demo DOCKER us-central1 ✅
```

## 🐳 Configure Docker for GCP

```bash
gcloud auth configure-docker \
  us-central1-docker.pkg.dev
# Answer: Y
echo "✅ Docker configured!"
```

## 🔥 Open Firewall Ports

### 📱 Manual Way

### 💻 CLI Way
```bash
gcloud compute firewall-rules create allow-8080 \
  --allow=tcp:8080 \
  --source-ranges=0.0.0.0/0 \
  --project=$PROJECT_ID

gcloud compute firewall-rules create allow-9090 \
  --allow=tcp:9090 \
  --source-ranges=0.0.0.0/0 \
  --project=$PROJECT_ID

echo "✅ Firewall ports opened!"
```

## ⚠️ Common Mistakes

| Mistake | Fix |
|---------|-----|
| Give permissions late | Give ALL at start! |
| Forget storage.admin | Grant to both SAs! |
| Forget firewall ports | Open 8080 AND 9090! |
| Push before configure | Configure Docker first! |

## 💡 Next Step
→ [Docker Images](04-docker-images.md)
