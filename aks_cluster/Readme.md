# Provision AKS Cluster, Service Principal and Keyvault using Terraform modules

## Architecture Diagram
![aks_architecture](https://github.com/trinaya-kantevari/terraform_azure/blob/main/aks_cluster/aks.jpg)

## Overview
- We first create a service principal to provision and manage AKS cluster instead of using user credentials. The service principal stores it's client secret inside the key vault.
- We must create a keyvault to store the client credentials. After creating the keyvault, we create a secret where the client password actually lies.
- Now we create the AKS Cluster with our requirements and also specify the service principal with it's client id and client secret.
- We use modules to provision these. Modules help in reusability i.e, we can simply make changes to the variables values and run the same code to create another set of resources.

## Implementation
- In the root directory, create provider.tf and include the azurerm and azuread providers with appropriate versions.
- Create main.tf which is the main file where we call our modules.
- For our modules, create a folder called modules and under it create three separate folders(child modules) each for service principal, keyvault and aks.
- Under each of these modules, we create:
1. main.tf - configuration of all the required resources for the module.
2. variables.tf - variables required as input for main.tf to create the resources.
3. outputs.tf - the output variables which are the values after creating the resources. These must be mentioned in order to be used by other modules or the root main.tf

## Project Structure

```console
aks_cluster/
├── main.tf                     # Root module – wires all child modules together
├── provider.tf                 # Azure provider configuration
├── variables.tf                # Input variables for the root module
├── terraform.tfvars            # Variable values
└── modules/                    # Reusable Terraform modules
    ├── aks/                    # Azure Kubernetes Service (AKS) cluster
    │   ├── main.tf             # AKS resource definition
    │   ├── variables.tf        # AKS module input variables
    │   └── output.tf           # AKS-related outputs (kubeconfig, cluster info)
    │
    ├── keyvault/               # Azure Key Vault resources
    │   ├── main.tf             # Key Vault configuration
    │   ├── variables.tf        # Key Vault module input variables
    │   └── output.tf           # Key Vault outputs (IDs etc)
    │
    └── serviceprincipal/       # Entra ID Service Principal for AKS
        ├── main.tf             # Service Principal creation
        ├── variables.tf        # SP module input variables
        └── output.tf           # Client ID, client secret outputs
```

## Execution
- Login to your azure account from the azure cli using ```az login```.
- Initialize terraform in the root directory using ```terraform init```.
- View the changes that will be made by Terraform (dry run) before actually applying using ```terraform plan```.
- Apply the changes to actually create our resources on Azure using ```terraform apply```.
- Destroy the infrastructure when no longer needed using ```terraform destroy```.

## Best Practices
- Use custom modules to improve code reusability and maintainability.
- Manage sensitive data securely using Azure Key Vault.
- Use explicit dependencies to prevent resource creation errors. For example, to ensure resources like Service Principals are created before role assignments or other dependent resources.
- Fetch latest Kubernetes version.
- Create local kubeconfig file using Terraform for seamless cluster access.