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
}