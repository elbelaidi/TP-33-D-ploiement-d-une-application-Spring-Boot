#!/bin/bash

# Script de déploiement de l'application Spring Boot sur Kubernetes
# TP 33 - Déploiement d'une application Spring Boot

set -e

echo "=========================================="
echo "Déploiement de l'application Demo K8s"
echo "=========================================="

# Variables
NAMESPACE="lab-k8s"
IMAGE_NAME="demo-k8s:1.0.0"

# Étape 1: Build de l'application Maven
echo ""
echo "=== Étape 1: Build Maven ==="
mvn clean package -DskipTests

# Étape 2: Construction de l'image Docker
echo ""
echo "=== Étape 2: Construction de l'image Docker ==="
docker build -t $IMAGE_NAME .

# Étape 3: Configuration Minikube
echo ""
echo "=== Étape 3: Configuration Minikube ==="
echo "Exécution de: eval \$(minikube docker-env)"
eval $(minikube docker-env)
docker build -t $IMAGE_NAME .

# Étape 4: Création du namespace
echo ""
echo "=== Étape 4: Création du namespace $NAMESPACE ==="
kubectl create namespace $NAMESPACE

# Étape 5: Application des manifests Kubernetes
echo ""
echo "=== Étape 5: Déploiement sur Kubernetes ==="
kubectl apply -f k8s-configmap.yaml
kubectl apply -f k8s-deployment.yaml
kubectl apply -f k8s-service.yaml

# Étape 6: Attente du déploiement
echo ""
echo "=== Étape 6: Vérification du déploiement ==="
echo "Pods:"
kubectl get pods -n $NAMESPACE -w

echo ""
echo "Services:"
kubectl get svc -n $NAMESPACE

# Étape 7: Récupération de l'IP Minikube
echo ""
echo "=== Étape 7: IP Minikube ==="
MINIKUBE_IP=$(minikube ip)
echo "IP Minikube: $MINIKUBE_IP"

echo ""
echo "=========================================="
echo "Déploiement terminé avec succès!"
echo "=========================================="
echo ""
echo "Pour tester l'API:"
echo "curl http://$MINIKUBE_IP:30080/api/hello"
echo ""
echo "Pour voir les logs:"
echo "kubectl logs -f \$(kubectl get pods -n $NAMESPACE -l app=demo-k8s -o jsonpath='{.items[0].metadata.name}') -n $NAMESPACE"
echo ""
echo "Pour nettoyer:"
echo "./cleanup.sh"

