resource "aws_instance" "private_linux_instances" {
  count = 3

  ami                    = var.linux_ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private-ssh.id]

  tags = {
    Name = "private-instance-linux-${count.index}"
    OS   = "linux"
  }
}

resource "aws_instance" "private_ubuntu_instances" {
  count = 3

  ami                    = var.ubuntu_ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private-ssh.id]

  tags = {
    Name = "private-instance-ubuntu-${count.index}"
    OS   = "ubuntu"
  }
}

# Define the Ansible Controller Instance
resource "aws_instance" "ansible_controller" {
  ami                    = var.ansible_controller_ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.allow-ssh-for-private-instances.id]

  tags = {
    Name = "ansible-controller"
  }

  depends_on = [
    aws_instance.private_linux_instances,
    aws_instance.private_ubuntu_instances,
    aws_instance.bastion
  ]

  provisioner "file" {
    source      = "${path.module}/ansible/ec2-instances.playbook.yml"
    destination = "/home/${var.ubuntu_user}/ec2-instances.playbook.yml"

    connection {
      type                = "ssh"
      user                = var.ubuntu_user
      private_key         = file(var.private_key_path)
      host                = self.private_ip
      bastion_host        = aws_instance.bastion.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file(var.private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      <<-EOT
        for instance in ${join(" ", aws_instance.private_linux_instances[*].private_ip)}; do
          ssh-keyscan -H $instance >> /home/${var.ubuntu_user}/.ssh/known_hosts
        done
      EOT,
      <<-EOT
        for instance in ${join(" ", aws_instance.private_ubuntu_instances[*].private_ip)}; do
          ssh-keyscan -H $instance >> /home/${var.ubuntu_user}/.ssh/known_hosts
        done
      EOT
    ]

    connection {
      type                = "ssh"
      user                = var.ubuntu_user
      private_key         = file(var.private_key_path)
      host                = self.private_ip
      bastion_host        = aws_instance.bastion.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file(var.private_key_path)
    }
  }
}