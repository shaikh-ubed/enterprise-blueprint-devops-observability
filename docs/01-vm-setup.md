# 🖥️ Phase 1: VM Setup

## Overview
Create and configure GCP VM
as our working machine.

## VM Configuration

| Setting | Value |
|---------|-------|
| Name | otel |
| Region | us-central1 |
| Zone | us-central1-a |
| Machine type | e2-standard-4 |
| vCPU | 4 (2 cores) |
| Memory | 16 GB |
| OS | Ubuntu 24.04 LTS |
| Disk type | Standard persistent disk |
| Disk size | 100 GB |
| HTTP | ✅ Allowed |
| HTTPS | ✅ Allowed |

## 📱 Manual Way
console.cloud.google.com
→ Compute Engine → VM instances
→ CREATE INSTANCE
→ Fill in settings above
→ Click CREATE
→ Wait 2 minutes
## 💻 CLI Way

```bash
gcloud compute instances create otel \
  --zone=us-central1-a \
  --machine-type=e2-standard-4 \
  --image-family=ubuntu-2404-lts \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=100GB \
  --boot-disk-type=pd-standard \
  --tags=http-server,https-server \
  --project=deployandobserve
```

## ✅ Verify

```bash
gcloud compute instances list \
  --project=deployandobserve
# Expected: otel RUNNING ✅
```

## ⚠️ Common Mistakes

| Mistake | Fix |
|---------|-----|
| Ubuntu 26.04 | Use 24.04 LTS! |
| Default 10GB disk | Use 100GB! |
| SSD disk | Use Standard persistent! |
| Wrong zone | Check availability first! |

## 🔑 First Login

```bash
# SSH into VM (Browser SSH recommended!)
# GCP Console → Compute Engine
# → VM instances → Click SSH button

# Login with Gmail (first time only!)
gcloud auth login --no-launch-browser

# Set project
gcloud config set project deployandobserve
```

## 💡 Next Step
→ [Tools Installation](02-tools-installation.md)
