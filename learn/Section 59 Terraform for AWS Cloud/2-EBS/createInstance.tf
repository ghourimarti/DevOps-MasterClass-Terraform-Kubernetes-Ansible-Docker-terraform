
#################################################
#                 1. Create aws_key_pair
#################################################

resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key1"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}



#################################################
#                 2. Create aws_instance
#################################################

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.aws_region)
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name      = aws_key_pair.levelup_key.key_name

  vpc_security_group_ids = [aws_security_group.allow-levelup-ssh.id]
  subnet_id = aws_subnet.levelupvpc-public-1.id

  tags = {
    Name = "custom_instance"
  }

}


#################################################
#                 3. Create EBS resource
#################################################
#EBS resource Creation
resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "us-east-1a"
  size              = 50
  type              = "gp2"

  tags = {
    Name = "Secondary Volume Disk"
  }
}


#################################################
#                 4. Attach EBS volume
#################################################

#Attach EBS volume with AWS Instance
resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs-volume-1.id
  instance_id = aws_instance.MyFirstInstnace.id
}



#################################################
#################################################
#################################################
#Create AWS Instance
# resource "aws_instance" "MyFirstInstnace" {
#   ami           = lookup(var.AMIS, var.AWS_REGION)
#   instance_type = "t2.micro"
#   availability_zone = "us-east-2a"
#   key_name      = aws_key_pair.levelup_key.key_name

#   tags = {
#     Name = "custom_instance"
#   }
# }



