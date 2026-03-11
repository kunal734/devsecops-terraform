#!/bin/bash
set -e

# Update system
apt update -y
apt upgrade -y

# Install base tools
apt install -y docker.io curl wget unzip git

usermod -aG docker ubuntu

# -------------------------------
# Install K3s (Lightweight K8s)
# -------------------------------
curl -sfL https://get.k3s.io | sh -

# Wait for K3s to be ready
sleep 30

# Configure kubectl for ubuntu user
mkdir -p /home/ubuntu/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
chown -R ubuntu:ubuntu /home/ubuntu/.kube

# -------------------------------
# Install Jenkins
# -------------------------------
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  jenkins/jenkins:lts

# -------------------------------
# Install SonarQube
# -------------------------------
docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  sonarqube:lts-community

# -------------------------------
# Install Trivy
# -------------------------------
apt install -y apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb jammy main" | tee /etc/apt/sources.list.d/trivy.list
apt update
apt install -y trivy

# -------------------------------
# Install Helm
# -------------------------------
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# -------------------------------
# Install ArgoCD
# -------------------------------
kubectl create namespace argocd

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# -------------------------------
# Install Monitoring (Prometheus + Grafana)
# -------------------------------
kubectl create namespace monitoring

helm repo add prometheus https://prometheus-community.github.io/helm-charts
helm repo update

helm install kube-prometheus prometheus/kube-prometheus-stack -n monitoring