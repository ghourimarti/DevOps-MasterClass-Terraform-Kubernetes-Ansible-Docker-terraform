#################################################
#  1. Create AWS VPC
#################################################
# Create Instance uisng Custom VPC

module "develop-vpc" {
    source      = "../modules/vpc"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
}

resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}


#################################################
#  2. Create AWS VPC
#################################################
#Secutiry Group for Instances
resource "aws_security_group" "allow-ssh" {
  vpc_id      = module.develop-vpc.my_vpc_id
  name        = "allow-ssh-${var.ENVIRONMENT}"
  description = "security group that allows ssh traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "allow-ssh"
    Environmnent = var.ENVIRONMENT
  }
}

#################################################
#  3. Create AWS Instance
#################################################
# Create Instance Group
resource "aws_instance" "my-instance" {
  ami           = var.AMI_ID
  instance_type = var.INSTANCE_TYPE

  # the VPC subnet
  subnet_id = module.develop-vpc.public_subnets # element(module.develop-vpc.public_subnets, 0)
  availability_zone = "${var.AWS_REGION}a"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]


  # the public SSH key
  key_name = aws_key_pair.levelup_key.key_name

  tags = {
    Name         = "instance-${var.ENVIRONMENT}"
    Environmnent = var.ENVIRONMENT
  }
}
