#!/bin/bash

set -e

echo "Adding helm repo..."
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

echo "Generating token..."
TOKEN=$(openssl rand -hex 256)
echo "Your token ${TOKEN}"

echo "Creating namespace jupyterhub..."
kubectl create namespace jupyterhub || echo 0
kubectl create -n spark serviceaccount spark || echo 0
kubectl apply -f role.yaml

echo "Installing release..."
helm upgrade \
  --install jupyterhub jupyterhub/jupyterhub \
  --namespace jupyterhub \
  --values values.yaml \
  --debug \
  --set proxy.secretToken="${TOKEN}"
