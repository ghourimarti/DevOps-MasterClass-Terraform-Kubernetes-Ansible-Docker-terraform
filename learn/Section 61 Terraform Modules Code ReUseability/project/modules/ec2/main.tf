# #Provider
# provider "aws" {
# 	region = var.region
# }

#Module
# module "myvpc" {
#     source = "./../module/network"
# }

#Resource key pair
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.public_key_path)
}

#EC2 Instance
resource "aws_instance" "this" {
  ami                    = lookup(var.instance_ami, var.aws_region)
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.levelup_key.key_name

  tags = {
    Name        = "${var.environment_tag}-ec2"
    Environment = var.environment_tag
  }
}