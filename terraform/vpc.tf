module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false

  enable_dns_hostnames       = true
  manage_default_route_table = true
  default_route_table_tags = {
    Name = "example-vpc-default"
  }
}
