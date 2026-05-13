# 🔧 Phase 2: Tools Installation

## Overview
Install all required tools on VM.
Install in EXACT order below!

## Tools Required

| Tool | Version | Purpose |
|------|---------|---------|
| Docker | 29.4.3 | Build + run containers |
| kubectl | v1.28.15 | Control Kubernetes |
| GKE Auth Plugin | v35.0.1 | Connect to GKE |
| Git | 2.43.0 | Clone repository |
| Helm | v3.20.2 | Deploy 16 services |

## 💻 Installation Commands

### 1. Docker
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
docker --version
# Expected: Docker version 29.4.3 ✅
```

### 2. kubectl
```bash
curl -LO "https://dl.k8s.io/release/v1.28.15/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 \
  kubectl /usr/local/bin/kubectl
kubectl version --client
# Expected: Client Version: v1.28.15 ✅
```

### 3. GKE Auth Plugin ← NEVER SKIP!
```bash
sudo apt-get install -y \
  apt-transport-https ca-certificates gnupg

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
https://packages.cloud.google.com/apt cloud-sdk main" | \
  sudo tee \
  /etc/apt/sources.list.d/google-cloud-sdk.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  sudo apt-key --keyring \
  /usr/share/keyrings/cloud.google.gpg add -

sudo apt-get update && \
sudo apt-get install -y \
  google-cloud-cli-gke-gcloud-auth-plugin

gke-gcloud-auth-plugin --version
# Expected: Kubernetes v35.x.x ✅
```

### 4. Git
```bash
git --version
# Expected: git version 2.43.0 ✅
# Usually pre-installed!
```

### 5. Helm (Install before Helm deploy!)
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version --short
# Expected: v3.20.x ✅
```

## ✅ Verify All Tools
```bash
docker --version
kubectl version --client
gke-gcloud-auth-plugin --version
git --version
helm version --short
```

## 💾 Save Permanent Settings
```bash
cat << 'EOF' >> ~/.bashrc

# GCP Permanent Settings
export GOOGLE_CLOUD_PROJECT=deployandobserve
export REGISTRY=us-central1-docker.pkg.dev/deployandobserve/otel-demo
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export ZONE=us-central1-a
gcloud config set project deployandobserve 2>/dev/null
gcloud config set account shakeebopslogistics@gmail.com 2>/dev/null

EOF

source ~/.bashrc
echo $REGISTRY
```

## ⚠️ Common Mistakes

| Mistake | Fix |
|---------|-----|
| Skip GKE Auth Plugin | Install before cluster! |
| Install Helm too early | Install just before Helm deploy! |
| Install in Cloud Shell | Always install in VM! |

## 💡 Next Step
→ [GCP Setup](03-gcp-setup.md)
