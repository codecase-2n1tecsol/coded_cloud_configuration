#!/bin/bash

# Load service principal ID from the output file
SP_FILE="../dataReturns/sensitiveFiles/myappauth.json"
SP_ID=$(jq -r '.appId' $SP_FILE)

if [[ -z "$SP_ID" ]]; then
  echo "Service Principal ID not found in $SP_FILE"
  exit 1
fi

# Load variables from .env


# Assign Azure RBAC roles
az role assignment create --assignee $SP_ID --role "Contributor" --scope /subscriptions/$SUBSCRIPTION_ID
az role assignment create --assignee $SP_ID --role "Reader" --scope /subscriptions/$SUBSCRIPTION_ID_2/resourceGroups/$RESOURCE_GROUP
az role assignment create --assignee $SERVICE_PRINCIPAL_ID --role "Storage Blob Data Contributor" --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT
az role assignment create --assignee $SERVICE_PRINCIPAL_ID --role "Key Vault Reader" --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.KeyVault/vaults/$KEYVAULT_NAME
# additional roles

echo "RBAC roles assigned to Service Principal: $SP_ID"
