# Run this script to create the backend on azure.

# Variables for storage
let "randomIdentifier=$RANDOM*$RANDOM"
location="East US"
RESOURCE_GROUP_NAME="terraform-state-rg"
STORAGE_ACCOUNT_NAME="tfstate$randomIdentifier"
CONTAINER_NAME="tf-state"

# Create a resource group
echo "Creating $RESOURCE_GROUP_NAME in $location..."
az group create --name $RESOURCE_GROUP_NAME --location "$location"

# Create a general-purpose standard storage account
echo "Creating $STORAGE_ACCOUNT_NAME account..."
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --location "$location" --sku Standard_LRS --encryption-services blob


# Create a storage container in the storage account
echo "Creating $CONTAINER_NAME on $STORAGE_ACCOUNT_NAME storage account..."
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --auth-mode login

# To clean up resources created in this resource group
# az group delete --name terraform-state-rg