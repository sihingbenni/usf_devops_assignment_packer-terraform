resource "aws_instance" "private_instances" {
  count = 6

  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private-ssh.id]

  tags = {
    Name = "private-instance-${count.index}"
  }
}
