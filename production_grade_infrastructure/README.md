# Provisioining Production Grade Infrastructure on Azure using Terraform

## Project Objective: Deploy a scalable web application infrastructure

Deploy an application within Virtual Machine Scale Sets (VMSS) to automatically scale virtual machines based on auto scale settings. The VMSS is placed securely inside a Virtual Network within a subnet, which is protected by a Network Security Group to allow only the necessary traffic. A Load Balancer is provisioned to distribute traffic across the virtual machines, and a NAT Gateway is provisioned to securely provide internet access for the virtual machines. Provision Public IPs for the Load Balancer and NAT Gateway.


