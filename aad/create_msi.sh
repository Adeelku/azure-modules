
set -e
## aks params
LOCATION=$(cat ./msi-params.yaml| grep LOCATION | awk '{print $2}')
RG_NAME=$(cat ./msi-params.yaml| grep RG_NAME | awk '{print $2}')
MSI_NAME=$(cat ./msi-params.yaml| grep MSI_NAME | awk '{print $2}')

### create Microsoft Managed Identity
echo "Creating RG"
az group create --name $RG_NAME --location $LOCATION

echo "creating MSI $MSI_NAME"
az identity create \
--resource-group $RG_NAME \
--name $MSI_NAME
