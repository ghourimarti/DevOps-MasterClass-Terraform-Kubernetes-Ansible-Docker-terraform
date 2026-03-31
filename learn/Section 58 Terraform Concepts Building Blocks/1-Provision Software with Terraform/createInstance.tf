######################################################
#               Resource 1 aws_key_pair
######################################################
resource "aws_key_pair" "levelup_key" {
  key_name = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

######################################################
#               Resource 2 aws_security_group
######################################################
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}


######################################################
#               Resource 3 aws_instance
######################################################
# Resource 3 aws_instance
resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.aws_region)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name
  # vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  # associate_public_ip_address = true

  # Optional: shutdown behavior
  instance_initiated_shutdown_behavior = "stop"

  # Optional: enable detailed monitoring
  monitoring = true

  # Optional: configure EC2 metadata service
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  # Optional: configure root EBS volume
  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name = "zohee_root_disk"
    }
  }


  tags = {
    Name        = "zohee_instance"
    Environment = "dev"
    Project     = "terraform-learning"
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