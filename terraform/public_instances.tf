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
