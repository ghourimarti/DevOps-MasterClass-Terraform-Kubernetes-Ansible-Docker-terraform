
######################################################
#               Resource 1 data aws_availability_zones
######################################################

data "aws_availability_zones" "avilable" {}


######################################################
#               Resource 2 data aws_ami
######################################################

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    # values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


######################################################
#               Resource 2 aws_instance
######################################################

resource "aws_instance" "MyFirstInstnace" {
  ami           = data.aws_ami.latest-ubuntu.id # lookup(var.AMIS, var.aws_region) 
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.avilable.names[0]

  tags = {
    Name = "custom_instance"
  }

}


######################################################
#               Resource 2 aws_instance
######################################################

output "____________________aws_instance____________________" {
  value = {
    ami           = data.aws_ami.latest-ubuntu.id
    instance_type = aws_instance.MyFirstInstnace.instance_type
    availability_zone = data.aws_availability_zones.avilable.names[0]
    tags = aws_instance.MyFirstInstnace.tags  
    owner = data.aws_ami.latest-ubuntu.owners[0]

  }
}