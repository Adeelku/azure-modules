##!/usr/bin/env bash
RG_NAME=$(cat ./aks-params.yaml| grep RG_NAME | awk '{print $2}')
echo "Deleting Resource Group $RG_NAME" 
az group delete --name $RG_NAME -y
