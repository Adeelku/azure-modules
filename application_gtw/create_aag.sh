LOCATION=$(cat ./aag-params.yaml| grep LOCATION | awk '{print $2}')
NET_RG_NAME=$(cat ./aag-params.yaml| grep NET_RG_NAME | awk '{print $2}')
VMET_NAME=$(cat ./aag-params.yaml| grep VMET_NAME | awk '{print $2}')
SNET_NAME=$(cat ./aag-params.yaml| grep SNET_NAME | awk '{print $2}')
AAG_SNET_NAME=$(cat ./aag-params.yaml| grep AAG_SNET_NAME | awk '{print $2}')
AAG_NAME=$(cat ./aag-params.yaml| grep AAG_NAME | awk '{print $2}')
AAG_PUBIP=$(cat ./aag-params.yaml| grep AAG_PUBIP | awk '{print $2}')
AAG_SNET_CIDR=$(cat ./aag-params.yaml| grep AAG_SNET_CIDR | awk '{print $2}')

set -e
## create application gateway subnet
az network vnet subnet create \
  --name $AAG_SNET_NAME \
  --resource-group $NET_RG_NAME \
  --vnet-name $VMET_NAME \
  --address-prefix $AAG_SNET_CIDR

## create applcation gateway pub ip
az network public-ip create \
  --resource-group $NET_RG_NAME \
  --name $AAG_PUBIP \
  --allocation-method Static \
  --sku Standard

## create application gatway
az network application-gateway create \
  --name $AAG_NAME \
  --location $LOCATION \
  --resource-group $NET_RG_NAME \
  --sku Standard_v2 \
  --http-settings-cookie-based-affinity disabled \
  --public-ip-address $AAG_PUBIP \
  --vnet-name $VMET_NAME \
  --subnet $AAG_SNET_NAME