resource "aws_instance" "private_linux_instances" {
  depends_on = [aws_instance.ansible_controller]
  count = 3

  ami                    = var.linux_ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private-ssh.id]

  tags = {
    Name = "private-instance-linux-${count.index}"
    OS   = "linux"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ec2-user/.ssh",
      "echo ${file("/tmp/ansible_controller_key.pub")} >> /home/ec2-user/.ssh/authorized_keys",
      "chmod 600 /home/ec2-user/.ssh/authorized_keys",
      "chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/tmp/ansible_controller_key")
      host        = self.private_ip
      bastion_host = aws_instance.ansible_controller.public_ip
      bastion_user = "ec2-user"
      bastion_private_key = file("/tmp/ansible_controller_key")
    }
  }
}

resource "aws_instance" "private_ubuntu_instances" {
  depends_on = [aws_instance.ansible_controller]
  count = 3

  ami                    = var.ubuntu_ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private-ssh.id]

  tags = {
    Name = "private-instance-ubuntu-${count.index}"
    OS   = "ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ubuntu/.ssh",
      "echo ${file("/tmp/ansible_controller_key.pub")} >> /home/ubuntu/.ssh/authorized_keys",
      "chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/tmp/ansible_controller_key")
      host        = self.private_ip
      bastion_host = aws_instance.ansible_controller.public_ip
      bastion_user = "ec2-user"
      bastion_private_key = file("/tmp/ansible_controller_key")
    }
  }
}

# Define the Ansible Controller Instance
resource "aws_instance" "ansible_controller" {
  ami           = var.ubuntu_ami_id
  instance_type = "t2.micro"
  key_name      = "ansible-controller-key"
  subnet_id     = aws_subnet.private.id

  provisioner "local-exec" {
    command = <<EOT
      ssh-keygen -t rsa -b 2048 -f /tmp/ansible_controller_key -q -N ""
      aws ec2 import-key-pair --key-name ansible-controller-key --public-key-material fileb:///tmp/ansible_controller_key.pub
    EOT
  }

  tags = {
    Name = "ansible-controller"
  }
}