# Provision Production Grade Infrastructure to Deploy a Scalable Application on Azure using Terraform

## Architecture Diagram

![prod_infra](https://github.com/trinaya-kantevari/terraform_azure/blob/main/production_grade_infrastructure/Prod_Diagram.jpg)

## Requirements

Azure Account - create a free account [here](https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account).

Azure CLI - install from [here](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest&pivots=msi).

Terraform - install from [here](https://developer.hashicorp.com/terraform/install).

VS Code - install from [here](https://code.visualstudio.com/download).

## Implementation

Run ```az login``` to authenticate to your Azure account through the Azure CLI. Terraform uses this authentication to manage Azure resources.

Run ```terraform init``` to initialize a Terraform working directory. This downloads provider plugins, initializes the backend, and configures state so Terraform can run.

Run ```terraform plan``` to view exactly what actions (create, modify, or destroy) Terraform will take to match your infrastructure to your configuration, without actually applying those changes.

Run ```terraform apply --auto-approve``` to execute the actions proposed in the terraform plan, creating, updating, or destroying infrastructure to match the desired state defined in your configuration files.