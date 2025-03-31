#!/bin/bash

# Function to add or update a line in /etc/hosts
add_or_update_host() {
  local ip="$1"
  local hostname="$2"
  local entry="$${ip} $${hostname}"

  # Check if the entry already exists
  if grep -q "$${hostname}" /etc/hosts; then
    # Replace the existing entry with the new one
    sudo sed -i "/$${hostname}/c\\$${entry}" /etc/hosts
  else
    # Add the new entry to the end of the file
    echo "$${entry}" | sudo tee -a /etc/hosts > /dev/null
  fi
}

# Add the Ansible Controller to the /etc/hosts file
add_or_update_host "${ansible_controller_ip}" "ansible-controller"

# Add the private instances to the /etc/hosts file

# Linux instances
%{ for instance in jsondecode(private_linux_instances) ~}
add_or_update_host "${instance.private_ip}" "${instance.tags.Name}"
%{ endfor ~}
# Ubuntu instances
%{ for instance in jsondecode(private_ubuntu_instances) ~}
add_or_update_host "${instance.private_ip}" "${instance.tags.Name}"
%{ endfor ~}