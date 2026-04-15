# DEPLOY A THREE TIER ARCHITECTURE
## Architecture Diagram
![architecture_diagram](https://github.com/trinaya-kantevari/terraform_azure/blob/main/three_tier_deployment/3_tier_arch.jpg)

## Overview

### Components:

1. Resource Group

1. VNet

2. Public Subnets: 3-tier architecture uses separate subnets for public (front-end), private (backend), and database tiers, enabling different networking rules and secure access control through Network Security Groups that control traffic based on defined rules to each layer.

3. Private Subnet

3. Database Subnet: Managed PostgreSQL database and read replica deliver high availability through asynchronous database sync between primary and replica in a master-slave architecture, ensuring failover capabilities for production workloads.

3. App Gateway Subnet: and Web Application Firewall (WAF) in the App Gateway public subnet protect against DDoS and presentation layer attacks.

4. Bastion Subnet

6. VMSS: Virtual Machine Scale Sets (VMSS) provide high availability and fault tolerance by automatically provisioning identical VMs from templates if one fails using health probes to check / and /health paths.

7. Load Balancer

4. NAT Gateway: Azure NAT Gateway allows private subnet instances to pull Docker images and update packages without exposing them to intrusion and traffic interception risks.

5. DNS

4. Keyvault: Azure Key Vault stores database credentials (host, username, password, name, port, SSL mode) as secrets.

Public IPs: 

User data scripts in the compute module install Docker, run containers, and fetch secrets from Key Vault, automating the application deployment process during VM provisioning.

Azure deployment requires Service Principal authentication setup for Terraform to provision resources, with Terraform initialization commands (init, plan, apply) executing the deployment after configuring Resource Group and Storage Account for backend state management.


## Infrastructure as Code
- Terraform custom modules standardize resource provisioning templates for production-grade infrastructure with best practices, specifying VM types and OS images that cannot be overridden to maintain consistency across deployments.

- Terraform count and count.index create two public subnets for front-end and two private subnets for back-end and database, with Bastion, application gateway, and NSG rules controlling access to front-end (HTTP/HTTPS) and private subnets (VNet only).

- Separate Terraform variable files for each environment (prod, test, dev) enable different configurations, with separate backend.tf for prod preventing accidental changes and Docker credentials stored in Key Vault for security.


## Execution

[Demonstration](https://youtu.be/x0qfBTMy_LQ)

- Login to your azure account from the azure cli using ```az login```.
- Initialize terraform in the root directory using ```terraform init```.
- View the changes that will be made by Terraform (dry run) before actually applying using ```terraform plan```.
- Apply the changes to actually create our resources on Azure using ```terraform apply```.
- Destroy the infrastructure when no longer needed using ```terraform destroy```.
