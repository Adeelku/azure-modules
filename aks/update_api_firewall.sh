
RG_NAME=$(cat ./aks-params.yaml| grep RG_NAME | awk '{print $2}')
CLUSTER_NAME=$(cat ./aks-params.yaml| grep CLUSTER_NAME | awk '{print $2}')

AUTH_IP=$(wget -qO- https://ipecho.net/plain ; echo)
az aks update \
    --resource-group $RG_NAME \
    --name $CLUSTER_NAME
    --api-server-authorized-ip-ranges "${AUTH_IP}/32"
 