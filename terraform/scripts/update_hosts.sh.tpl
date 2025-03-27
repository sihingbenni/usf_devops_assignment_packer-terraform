#!/bin/bash

# Add the Ansible Controller to the /etc/hosts file
echo "${ansible_controller_ip} ansible-controller" | sudo tee -a /etc/hosts

# Add the private instances to the /etc/hosts file

# Linux instances
%{ for instance in jsondecode(private_linux_instances) ~}
  echo "${instance.private_ip} ${instance.tags.Name}" | sudo tee -a /etc/hosts
%{ endfor ~}
# Ubuntu instances
%{ for instance in jsondecode(private_ubuntu_instances) ~}
  echo "${instance.private_ip} ${instance.tags.Name}" | sudo tee -a /etc/hosts
%{ endfor ~}