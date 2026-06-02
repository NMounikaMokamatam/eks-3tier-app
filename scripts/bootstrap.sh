#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${1:-eks-3tier-cluster}"
REGION="${2:-us-east-1}"
ARGOCD_VERSION="v2.10.0"

echo "==> Configuring kubectl for $CLUSTER_NAME"
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$REGION"

echo "==> Creating namespaces"
kubectl apply -f k8s/namespaces/

echo "==> Installing ArgoCD $ARGOCD_VERSION"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f \
  "https://raw.githubusercontent.com/argoproj/argo-cd/$ARGOCD_VERSION/manifests/install.yaml"
kubectl wait --for=condition=available deployment/argocd-server \
  -n argocd --timeout=120s

echo "==> Installing Prometheus + Grafana"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace \
  -f k8s/monitoring/prometheus-values.yaml --wait

echo "==> Applying ArgoCD Application"
kubectl apply -f argocd/application.yaml

echo ""
echo "✅ Bootstrap complete!"
echo "   ArgoCD password: kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d"
echo "   Port-forward:    kubectl port-forward svc/argocd-server -n argocd 8080:443"
