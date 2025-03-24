resource "aws_instance" "private_instances" {
  count = 6

  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.private_subnets[0]

  tags = {
    Name = "example-private-instance-${count.index}"
  }
}
