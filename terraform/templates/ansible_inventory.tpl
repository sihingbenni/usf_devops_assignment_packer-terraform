[ubuntu_servers]
%{ for instance in ubuntu_instances ~}
${instance.tags.Name} ansible_host=${instance.private_ip}
%{ endfor ~}

[linux_servers]
%{ for instance in linux_instances ~}
${instance.tags.Name} ansible_host=${instance.private_ip}
%{ endfor ~}

[ubuntu_servers:vars]
ansible_user=${ubuntu_user}
ansible_ssh_private_key_file=/home/${ubuntu_user}/.ssh/id_rsa

[linux_servers:vars]
ansible_user=${linux_user}
ansible_ssh_private_key_file=/home/${ubuntu_user}/.ssh/id_rsa
