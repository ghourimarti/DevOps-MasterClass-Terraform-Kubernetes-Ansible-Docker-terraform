
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.aws_region)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name

  tags = {
    Name = "custom_instance"
  }

  provisioner "file" {
      source = "installNginx.sh"
      destination = "/tmp/installNginx.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installNginx.sh",
      "sudo sed -i -e 's/\r$//' /tmp/installNginx.sh",  # Remove the spurious CR characters.
      "sudo /tmp/installNginx.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}










# createInstance.tf

# resource "aws_default_vpc" "default" {
# }

# resource "aws_default_subnet" "default_az1" {
#   availability_zone = "${var.aws_region}a"
# }

# resource "aws_key_pair" "levelup_key" {
#   key_name   = "levelup_key"
#   public_key = file(var.PATH_TO_PUBLIC_KEY)
# }

# resource "aws_security_group" "allow_ssh_http" {
#   name        = "allow_ssh_http"
#   description = "Allow SSH and HTTP traffic"
#   vpc_id      = aws_default_vpc.default.id

#   ingress {
#     description = "SSH Access"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "HTTP Access"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow_ssh_http"
#   }
# }

# resource "aws_instance" "MyFirstInstnace" {
#   ami           = lookup(var.AMIS, var.aws_region)
#   instance_type = "t2.micro"

#   key_name = aws_key_pair.levelup_key.key_name

#   subnet_id              = aws_default_subnet.default_az1.id
#   vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

#   associate_public_ip_address = true

#   tags = {
#     Name = "custom_instance"
#   }

#   provisioner "file" {
#     source      = "installNginx.sh"
#     destination = "/tmp/installNginx.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/installNginx.sh",
#       "sudo sed -i -e 's/\r$//' /tmp/installNginx.sh",
#       "sudo /tmp/installNginx.sh"
#     ]
#   }

#   connection {
#     type        = "ssh"
#     host        = self.public_ip
#     user        = var.INSTANCE_USERNAME
#     private_key = file(var.PATH_TO_PRIVATE_KEY)
#   }
# }