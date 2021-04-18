#!/bin/bash

snap alias microk8s.kubectl kubectl
printf "\nEnabling DNS,Registry, helm3.\n"
microk8s.enable dns
micrk8s.enable registry
microk8s.enable helm
microk8s.enable helm3


printf "\nStarting to build the docker file\n"
docker build . -t flinksnginx:1.0.0
docker save flinksnginx > flinksnginx.tar
microk8s.ctr image import flinksnginx.tar
microk8s.enable ingress


printf "\nCreating the namespace\n"
kubectl create namespace flinks

printf "\Starting to create the workload\n"
kubectl apply -f deployment.yaml

printf "\n starting to create service\n"
kubectl apply -f service.yaml

printf "\nApplying ingress for nginx\n"
kubectl apply -f ingress.yaml

echo "127.0.0.1  challenge.domain.local" | tee /etc/hosts