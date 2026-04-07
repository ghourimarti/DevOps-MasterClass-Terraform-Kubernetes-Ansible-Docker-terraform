#################################################
#  1. Create AWS VPC
#################################################
resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

#################################################
#  2. Create Public Subnets: vpc ---> public subnet
#################################################
# Public Subnets in Custom VPC
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
    Type = "public"
  }
}

#################################################
# 3. Create Private Subnets: vpc ---> private subnet
#################################################
# Custom internet GatewayPrivate Subnets in Custom VPC
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
    Type = "private"
  }
}

#################################################
#  4. Create Internet Gateway
#################################################
# Custom internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# 5,6 = levelupvpc-public-1,2,3(subnet) ---> levelup-public(route table) ---> levelup-gw(internet gateway)
#################################################
#  5. Create Route Table: levelup-public ---> levelup-gw
#################################################
# Creating Table for the Custom VPC
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

###################################################
# 6. Create Route Table Association: levelupvpc-public-1,2,3 ---> levelup-public
###################################################
# 
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
