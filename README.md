# Spring Boot AKS Demo

What is included:
- Minimal Spring Boot app (Maven)
- Dockerfile (multi-stage)
- Kubernetes manifests (namespace, deployment, service, ingress, HPA)

Quick steps:
1. Build & test locally:
   mvn -B -DskipTests package

2. Build and push image (example using ACR):
   # replace <ACR_NAME> with your ACR login server (e.g. myacr.azurecr.io)
   docker build -t <ACR_NAME>.azurecr.io/springboot-demo:latest .
   az acr login --name <ACR_NAME>
   docker push <ACR_NAME>.azurecr.io/springboot-demo:latest

3. Create Kubernetes namespace and deploy:
   kubectl apply -f k8s/namespace.yaml
   kubectl apply -f k8s/deployment.yaml
   kubectl apply -f k8s/service.yaml
   kubectl apply -f k8s/ingress.yaml
   kubectl apply -f k8s/hpa.yaml

Notes for AKS:
- If your ACR is in the same subscription as AKS, configure AKS to pull from ACR:
  az aks update -n <AKS_CLUSTER> -g <RESOURCE_GROUP> --attach-acr <ACR_NAME>
- Alternatively create a secret:
  kubectl create secret docker-registry acr-secret \
    --docker-server=<ACR_NAME>.azurecr.io \
    --docker-username=<USERNAME> \
    --docker-password=<PASSWORD> \
    -n springboot-demo
  then add 'imagePullSecrets: - name: acr-secret' under spec.template.spec in deployment.yaml

- Ingress assumes an nginx ingress controller is installed in-cluster. For AKS you can install it via:
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update
  helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

Customize as needed (replicas, resource requests/limits, probe paths, env vars).
