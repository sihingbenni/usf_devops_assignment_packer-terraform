# The Bastion Host
resource "aws_instance" "bastion" {
  ami                    = var.linux_ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion-allow-ssh.id]

  tags = {
    Name = "bastion-host"
  }
}

# NAT Instance
resource "aws_instance" "nat_instance" {
  ami                         = "ami-084568db4383264d4" # Ubuntu 24.04 LTS"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  source_dest_check           = false
  tags = {
    Name = "nat-instance"
  }
}
