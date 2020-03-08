##!/usr/bin/env bash

set -e
## aks params
LOCATION=$(cat ./aks-params.yaml| grep LOCATION | awk '{print $2}')
RG_NAME=$(cat ./aks-params.yaml| grep RG_NAME | awk '{print $2}')
CLUSTER_NAME=$(cat ./aks-params.yaml| grep CLUSTER_NAME | awk '{print $2}')
NODE_SIZE=$(cat ./aks-params.yaml| grep NODE_SIZE | awk '{print $2}')
NODE_COUNT=$(cat ./aks-params.yaml| grep NODE_COUNT | awk '{print $2}')
NODE_DISK_SIZE=$(cat ./aks-params.yaml| grep NODE_DISK_SIZE | awk '{print $2}')
VERSION=$(cat ./aks-params.yaml| grep VERSION | awk '{print $2}')
CNI_PLUGIN=$(cat ./aks-params.yaml| grep CNI_PLUGIN | awk '{print $2}')

## network params
NET_RG_NAME=$(cat ../networking/net-params.yaml| grep NET_RG_NAME | awk '{print $2}')
VMET_NAME=$(cat ../networking/net-params.yaml| grep VMET_NAME | awk '{print $2}')
SNET_NAME=$(cat ../networking/net-params.yaml| grep SNET_NAME | awk '{print $2}')

# The following will restrict access to the API server from your Public IP
AUTH_IP=$(wget -qO- https://ipecho.net/plain ; echo)

## create vnet
echo "Creating VNet"
cd ../networking
./create_vnet.sh

## get subnet info
echo "Getting Subnet ID"
SNET_ID=$(az network vnet subnet show \
  --resource-group $NET_RG_NAME \
  --vnet-name $VMET_NAME \
  --name $SNET_NAME \
  --query id -o tsv)

### create aks cluster
echo "Creating AKS RG"
az group create --name $RG_NAME --location $LOCATION
echo "Creating AKS Cluster"
az aks create --resource-group $RG_NAME --name $CLUSTER_NAME \
  --kubernetes-version $VERSION \
  --location $LOCATION \
  --node-vm-size $NODE_SIZE \
  --load-balancer-sku standard \
  --api-server-authorized-ip-ranges "${AUTH_IP}/32" \
  --node-count $NODE_COUNT --node-osdisk-size $NODE_DISK_SIZE \
  --network-plugin $CNI_PLUGIN \
  --vnet-subnet-id $SNET_ID \
  --docker-bridge-address 172.17.0.1/16 \
  --dns-service-ip 10.2.0.10 \
  --service-cidr 10.2.0.0/24 

# connect to the cluster
az aks get-credentials --resource-group $RG_NAME --name $CLUSTER_NAME
