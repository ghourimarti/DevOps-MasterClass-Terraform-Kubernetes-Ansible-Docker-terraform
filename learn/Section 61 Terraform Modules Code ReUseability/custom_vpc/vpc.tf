# VPC
#################################################
#  1. Create AWS VPC
#################################################

resource "aws_vpc" "levelupvpc" { #resource "aws_vpc" "aws_vpc_levelup" {

  cidr_block                       = var.cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  # enable_classiclink               = var.enable_classiclink
  # enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = {
      name = var.vpcname
      environment = var.vpcenvironment
  }
  
}








# resource "aws_vpc" "levelupvpc" {
#   cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"
#   enable_dns_support   = "true"
#   enable_dns_hostnames = "true"
#   # enable_classiclink = "false"

#   tags = {
#     Name = "levelupvpc"
#   }
# }

#################################################
#  2. Create Public Subnets: vpc ---> public subnet
#################################################
# Public Subnets in Custom VPC
resource "aws_subnet" "levelupvpc-public-1" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "levelupvpc-public-1"
  }
}

resource "aws_subnet" "levelupvpc-public-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "levelupvpc-public-2"
  }
}

resource "aws_subnet" "levelupvpc-public-3" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "levelupvpc-public-3"
  }
}

#################################################
# 3. Create Private Subnets: vpc ---> private subnet
#################################################
# Custom internet GatewayPrivate Subnets in Custom VPC

resource "aws_subnet" "levelupvpc-private-1" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1d"

  tags = {
    Name = "levelupvpc-private-1"
  }
}

resource "aws_subnet" "levelupvpc-private-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1e"

  tags = {
    Name = "levelupvpc-private-2"
  }
}

resource "aws_subnet" "levelupvpc-private-3" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1f"

  tags = {
    Name = "levelupvpc-private-3"
  }
}

#################################################
#  4. Create Internet Gateway
#################################################
# Custom internet Gateway
resource "aws_internet_gateway" "levelup-gw" {
  vpc_id = aws_vpc.levelupvpc.id

  tags = {
    Name = "levelup-gw"
  }
}


# 5,6 = levelupvpc-public-1,2,3(subnet) ---> levelup-public(route table) ---> levelup-gw(internet gateway)
#################################################
#  5. Create Route Table: levelup-public ---> levelup-gw
#################################################
# Creating Table for the Custom VPC
resource "aws_route_table" "levelup-public" {
  vpc_id = aws_vpc.levelupvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.levelup-gw.id
  }

  tags = {
    Name = "levelup-public"
  }
}

###################################################
# 6. Create Route Table Association: levelupvpc-public-1,2,3 ---> levelup-public
###################################################
# 
resource "aws_route_table_association" "levelup-public-1-a" {
  subnet_id      = aws_subnet.levelupvpc-public-1.id
  route_table_id = aws_route_table.levelup-public.id
}

resource "aws_route_table_association" "levelup-public-2-a" {
  subnet_id      = aws_subnet.levelupvpc-public-2.id
  route_table_id = aws_route_table.levelup-public.id
}

resource "aws_route_table_association" "levelup-public-3-a" {
  subnet_id      = aws_subnet.levelupvpc-public-3.id
  route_table_id = aws_route_table.levelup-public.id
}
