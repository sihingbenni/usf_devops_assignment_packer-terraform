resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/ansible_inventory.tpl", {
    ubuntu_instances = aws_instance.private_ubuntu_instances[*]
    linux_instances  = aws_instance.private_linux_instances[*]
    ubuntu_user      = var.ubuntu_user
    linux_user       = var.linux_user
  })
  filename = "${path.module}/generated/inventory.ini"
}


# Upload inventory to controller
resource "null_resource" "deploy_inventory" {
  depends_on = [
    aws_instance.ansible_controller,
    aws_instance.private_linux_instances,
    aws_instance.private_ubuntu_instances,
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = local_file.ansible_inventory.filename
    destination = "/home/${var.ubuntu_user}/inventory.ini"

    connection {
      type                = "ssh"
      user                = var.ubuntu_user
      private_key         = file(var.private_key_path)
      host                = aws_instance.ansible_controller.private_ip
      bastion_host        = aws_instance.bastion.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file(var.private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/ansible",
      "sudo mv /home/${var.ubuntu_user}/inventory.ini /etc/ansible/hosts",
      "sudo chmod 644 /etc/ansible/hosts"
    ]

    connection {
      type                = "ssh"
      user                = var.ubuntu_user
      private_key         = file(var.private_key_path)
      host                = aws_instance.ansible_controller.private_ip
      bastion_host        = aws_instance.bastion.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file(var.private_key_path)
    }
  }
}
