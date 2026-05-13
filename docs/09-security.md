# 🔒 Phase 9: Security

## Overview
Enterprise security implementation
using Zero Trust principles,
RBAC and Network Policies.

## 💡 Security Framework
Standards followed:
→ ISO 27001 ✅
→ NIST Cybersecurity Framework ✅
→ Zero Trust Networking ✅
→ Least Privilege Principle ✅

## 🔐 4 Security Layers

| Layer | Implementation |
|-------|---------------|
| GCP Level | IAM, VPC, Firewall, Cloud Armor |
| GKE Level | RBAC, Network Policies, Pod Security |
| Container | Image scanning, non-root, read-only FS |
| Application | Secrets management, TLS, service mesh |

## 👥 RBAC — 3 Roles

### Check Existing Roles First!
```bash
kubectl get roles -n otel-demo
```

### Developer Role
```bash
# Can deploy but cannot delete!
kubectl create role developer \
  --verb=get,list,watch,create,update,patch \
  --resource=pods,deployments,services \
  --namespace=otel-demo
echo "✅ Developer role created!"
```

### Viewer Role
```bash
# Read only access!
kubectl create role viewer \
  --verb=get,list,watch \
  --resource=pods,services,deployments \
  --namespace=otel-demo
echo "✅ Viewer role created!"
```

### Verify Roles
```bash
kubectl get roles -n otel-demo
kubectl describe role developer -n otel-demo
```

### 📱 View in Console
console.cloud.google.com
→ Kubernetes Engine
→ Security → Roles
→ See RBAC roles listed ✅

## 🌐 Network Policies — Zero Trust!

```bash
# Default deny ALL traffic first!
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: otel-demo
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF
echo "✅ Network Policy created!"
```

### Verify Network Policy
```bash
kubectl get networkpolicy -n otel-demo
```

### 📱 View in Console
console.cloud.google.com
→ Kubernetes Engine
→ Security → Network Policies
→ See default-deny-all ✅
## 🔍 Image Scanning

### 📱 Manual Way
console.cloud.google.com
→ Artifact Registry
→ otel-demo repository
→ Settings
→ Enable vulnerability scanning ✅

### What It Does
→ Scans images on push ✅
→ Detects CVEs ✅
→ Blocks critical vulnerabilities ✅
→ Shows scan results in Console ✅

## 🔑 Secret Management
Best practices:
→ No hardcoded passwords ✅
→ Use K8s Secrets ✅
→ Encrypted at rest ✅
→ Least privilege access ✅

## 📋 Security Checklist
✅ RBAC roles created
✅ Network policies applied
✅ Image scanning enabled
✅ No hardcoded secrets
✅ Non-root containers
✅ Least privilege IAM
✅ Audit logging enabled

## ⚠️ Common Mistakes

| Mistake | Fix |
|---------|-----|
| Creating duplicate roles | Check existing first! |
| No network policy | Apply default deny first! |
| Hardcoded passwords | Use K8s Secrets! |
| Root containers | Always runAsNonRoot: true! |

## 💡 Next Step
→ [Disaster Recovery](10-disaster-recovery.md)

