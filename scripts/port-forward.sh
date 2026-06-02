#!/usr/bin/env bash
set -euo pipefail

echo "==> Port-forwarding services (Ctrl+C to stop)"
echo "   Grafana → http://localhost:3001"
echo "   ArgoCD  → http://localhost:8080"
echo "   Backend → http://localhost:5000"

kubectl port-forward svc/monitoring-grafana -n monitoring 3001:80 &
kubectl port-forward svc/argocd-server      -n argocd     8080:443 &
kubectl port-forward svc/backend-svc        -n app        5000:5000 &

wait
