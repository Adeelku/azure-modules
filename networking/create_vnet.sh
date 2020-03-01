set -e

LOCATION=$(cat ./net-params.yaml| grep LOCATION | awk '{print $2}')
NET_RG_NAME=$(cat ./net-params.yaml| grep NET_RG_NAME | awk '{print $2}')
VMET_NAME=$(cat ./net-params.yaml| grep VMET_NAME | awk '{print $2}')
SNET_NAME=$(cat ./net-params.yaml| grep SNET_NAME | awk '{print $2}')
VNET_CIDR=$(cat ./net-params.yaml| grep VNET_CIDR | awk '{print $2}')
SNET_CIDR=$(cat ./net-params.yaml| grep SNET_CIDR | awk '{print $2}')

## create Resource Group for VNet
az group create --name $NET_RG_NAME --location $LOCATION

## Create VNet and SubNet
az network vnet create \
    -g $NET_RG_NAME \
    -n $VMET_NAME --address-prefix $VNET_CIDR \
    --subnet-name $SNET_NAME --subnet-prefix $SNET_CIDR
