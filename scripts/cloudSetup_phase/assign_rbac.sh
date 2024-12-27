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


### or 

#!/bin/bash

# Path to your .env file
ENV_FILE="../../.env"

# Load service principal ID from the output file
SP_FILE="../../dataReturns/sensitiveFiles/myappauth.json"
SP_ID=$(jq -r '.clientId' $SP_FILE)

if [[ -z "$SP_ID" ]]; then
  echo "Service Principal ID not found in $SP_FILE"
  exit 1
fi

# Load and export variables from the .env file
if [ -f "$ENV_FILE" ]; then
  set -a # Export all variables
  source "$ENV_FILE"
  set +a
else
  echo "Error: .env file not found at $ENV_FILE"
  exit 1
fi

# Use the variables
#echo "CLIENT_ID: $CLIENT_ID"
#echo "CLIENT_SECRET: $CLIENT_SECRET"
#echo "TENANT_ID: $TENANT_ID"

# Assign Azure RBAC roles
az role assignment create --assignee $CLIENT_ID --role "Contributor" --scope /subscriptions/$SUBSCRIPTION_ID
#az role assignment create --assignee $SP_ID --role "Reader" --scope /subscriptions/$SUBSCRIPTION_ID_2/resourceGroups/$RESOURCE_GROUP
#az role assignment create --assignee $SERVICE_PRINCIPAL_ID --role "Storage Blob Data Contributor" --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT
#az role assignment create --assignee $SERVICE_PRINCIPAL_ID --role "Key Vault Reader" --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.KeyVault/vaults/$KEYVAULT_NAME
#additional roles

echo "RBAC roles assigned to Service Principal: $SP_ID"
