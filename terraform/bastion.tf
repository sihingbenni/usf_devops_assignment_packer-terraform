resource "aws_security_group" "bastion" {
  name        = "example-bastion-sg"
  description = "Allow inbound SSH traffic from your IP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from your IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip_address]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-bastion-sg"
  }
}

resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  tags = {
    Name = "example-bastion-host"
  }
}
