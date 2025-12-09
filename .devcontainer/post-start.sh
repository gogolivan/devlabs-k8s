#!/usr/bin/env bash
set -e

minikube start

# Wait until Kubernetes API is ready
echo "Waiting for Kubernetes cluster to be ready..."
until kubectl get nodes >/dev/null 2>&1; do
    echo -n "."
    sleep 2
done
echo "Kubernetes cluster is ready!"

# Wait until all nodes are Ready
echo "Waiting until all nodes are Ready..."
until kubectl get nodes --no-headers | awk '{print $2}' | grep -q "Ready"; do
    echo -n "."
    sleep 2
done
echo "All nodes are Ready!"

# Check if any Gateway API CRDs are already installed
if kubectl get crds | grep -q 'gateway'; then
    echo "Gateway API already installed. Skipping installation."
else
    echo "Installing Gateway API..."
    kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.0/standard-install.yaml
    echo "Gateway API installed successfully!"
fi

kubectl get crds | grep gateway
