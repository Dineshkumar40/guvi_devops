#!/bin/bash

set -e

echo "=========================================="
echo " Checking Docker"
echo "=========================================="

docker --version

echo ""
echo "Testing Docker access..."

docker ps

echo ""
echo "Docker is working correctly."


echo ""
echo "=========================================="
echo " Checking Minikube"
echo "=========================================="

minikube version


echo ""
echo "=========================================="
echo " Checking kubectl"
echo "=========================================="

kubectl version --client


echo ""
echo "=========================================="
echo " Starting Minikube"
echo "=========================================="

minikube start --driver=docker


echo ""
echo "=========================================="
echo " Verifying Minikube"
echo "=========================================="

minikube status

echo ""
echo "Kubernetes nodes:"
kubectl get nodes

echo ""
echo "Kubernetes namespaces:"
kubectl get namespaces


echo ""
echo "=========================================="
echo " Minikube Started Successfully!"
echo "=========================================="
