# Assignment #10 - Ansible Playbook
## CS-486 - DevOps

---

## Prerequisites:
- AWS Account
- Packer installed ([Install Instructions](https://developer.hashicorp.com/packer/install))
- Terraform installed ([Install Instructions](https://developer.hashicorp.com/terraform/install))

## Instructions to Run:

Run the following commands to create three different ami's using packer:
1. `cd packer` to navigate to the packer directory
2. Copy the `variables.pkr.hcl.example` file to `variables.pkr.hcl` and fill in the required variables
3. Run `packer init .` to initialize the packer template
4. Run `packer validate .` to validate the packer template
5. Run `packer build .` to build the ubuntu, linux and ansible controller AMIs
6. Note down the AMI IDs for the ubuntu, linux and ansible controller AMIs

Run the following commands to provision AWS resources using Terraform:
1. `cd terraform` to navigate to the terraform directory
   1. (If needed cd back to the root directory and then navigate to the terraform directory)
2. Copy the `terraform.tfvars.example` file to `terraform.tfvars` and fill in the required variables
3. Run `terraform init` to initialize the terraform modules
4. Run `terraform validate` to validate the terraform scripts
5. Run `terraform plan` to create and view the execution plan
6. Run `terraform apply` to apply the changes and provision the resources


(you need to connect with an ssh-agent via the bastion host):
1. `eval `ssh-agent -s`
2. `ssh-add <your-private-key>`
3. `ssh -A ec2-user@<bastion-public-dns>`
4. `ssh ubuntu@ansible-controller` (a host name exists for the ansible controller)

Run the following commands on the ansible-controller to run the playbook:
1. `ansible-playbook ec2-instances.playbook.yml`
