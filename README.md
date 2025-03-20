# Assignment #8 - Packer & Terraform
## CS-486 - DevOps

---
This repository is splint into two parts:

### Task A: Packer
#### Create a custom AWS AMI using Packer that contains the following:
- Amazon Linux 
- Docker 
- Your SSH public key is set so you can log in using your private key

### Task B: Terraform
#### Create Terraform scripts to provision AWS resources:
- VPC, private subnets, public subnets, all necessary routes (use modules)
- 1 bastion host in the public subnet (accept only your IP on port 22)
- 6 EC2 instances in the private subnet using your new AMI created from Packer

---

## Prerequisites:
- AWS Account
- Packer installed ([Install Instructions](https://developer.hashicorp.com/packer/install))
- Terraform installed ([Install Instructions](https://developer.hashicorp.com/terraform/install))

## Instructions to Run:

### Task A: Packer
Run the following commands to create a custom AWS AMI using Packer:


