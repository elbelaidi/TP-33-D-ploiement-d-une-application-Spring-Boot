#!/bin/bash

# Script de nettoyage du déploiement Kubernetes
# TP 33 - Déploiement d'une application Spring Boot

set -e

NAMESPACE="lab-k8s"

echo "=========================================="
echo "Nettoyage du déploiement Kubernetes"
echo "=========================================="

# Suppression des ressources Kubernetes
echo ""
echo "Suppression des ressources Kubernetes..."
kubectl delete -f k8s-service.yaml --ignore-not-found
kubectl delete -f k8s-deployment.yaml --ignore-not-found
kubectl delete -f k8s-configmap.yaml --ignore-not-found

# Suppression du namespace
echo ""
echo "Suppression du namespace $NAMESPACE..."
kubectl delete namespace $NAMESPACE --ignore-not-found

# Arrêt de Minikube (optionnel)
echo ""
echo "Voulez-vous arrêter Minikube? (o/n)"
read -r response
if [ "$response" = "o" ] || [ "$response" = "O" ]; then
    minikube stop
    echo "Minikube arrêté."
fi

echo ""
echo "=========================================="
echo "Nettoyage terminé!"
echo "=========================================="

