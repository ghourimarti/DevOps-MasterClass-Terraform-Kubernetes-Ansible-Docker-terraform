module "dev_vpc" {
  source = "../../modules/network"

  vpc_name              = "dev01-vpc"
  environment           = "Development-Engineering"
  cidr_block            = "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  enable_ipv6           = true

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  create_nat_gateway = true

  allowed_ssh_cidrs = ["0.0.0.0/0"]
}