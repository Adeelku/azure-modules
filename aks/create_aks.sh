##!/usr/bin/env bash

LOCATION=$(cat ./aks-params.yaml| grep LOCATION | awk '{print $2}')
RG_NAME=$(cat ./aks-params.yaml| grep RG_NAME | awk '{print $2}')
CLUSTER_NAME=$(cat ./aks-params.yaml| grep CLUSTER_NAME | awk '{print $2}')
NODE_SIZE=$(cat ./aks-params.yaml| grep NODE_SIZE | awk '{print $2}')
NODE_COUNT=$(cat ./aks-params.yaml| grep NODE_COUNT | awk '{print $2}')
NODE_DISK_SIZE=$(cat ./aks-params.yaml| grep NODE_DISK_SIZE | awk '{print $2}')
VERSION=$(cat ./aks-params.yaml| grep VERSION | awk '{print $2}')

# The following will restrict access to the API server from your Public IP
AUTH_IP=$(wget -qO- https://ipecho.net/plain ; echo)

### create the cluster
az group create --name $RG_NAME --location $LOCATION
az aks create --resource-group $RG_NAME --name $CLUSTER_NAME \
  --kubernetes-version $VERSION \
  --location $LOCATION \
  --node-vm-size $NODE_SIZE \
  --load-balancer-sku standard \
  --api-server-authorized-ip-ranges "${AUTH_IP}/32" \
  --node-count $NODE_COUNT --node-osdisk-size $NODE_DISK_SIZE
# connect to the cluster
az aks get-credentials --resource-group $RG_NAME --name $CLUSTER_NAME
