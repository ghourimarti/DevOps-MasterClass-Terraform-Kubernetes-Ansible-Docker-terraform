
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

##################################################################  
#  1. vpc
##################################################################

module "develop-vpc" {
    source      = "./modules/vpc"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
}


##################################################################  
#  1. aws_security_group:allow_elk
##################################################################


resource "aws_security_group" "allow_elk" {
  name        = "allow_elk"
  description = "All all elasticsearch traffic"
  vpc_id      = module.develop-vpc.my_vpc_id
  # elasticsearch port
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # logstash port
  ingress {
    from_port   = 5043
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # kibana ports
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################################  
#  1. Create AWS Instance
##################################################################
# Create AWS Instance
resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro" # "m4.large"

  # the VPC subnet
  subnet_id = element(module.develop-vpc.public_subnets, 0)
  availability_zone = "${var.AWS_REGION}a"

  # the security group
  # vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
  vpc_security_group_ids = [
    aws_security_group.allow_elk.id,
  ]

  # the public SSH key
  key_name = aws_key_pair.levelup_key.key_name

  tags = {
    Name         = "instance-${var.ENVIRONMENT}"
    Environmnent = var.ENVIRONMENT
  }


  depends_on = [aws_security_group.allow_elk]

  provisioner "file" {
      source = "elasticsearch.yml"
      destination = "/tmp/elasticsearch.yml"
  }

  provisioner "file" {
      source = "kibana.yml"
      destination = "/tmp/kibana.yml"
  }

  provisioner "file" {
      source = "apache-01.conf"
      destination = "/tmp/apache-01.conf"
  }

    provisioner "file" {
      source = "installELK.sh"
      destination = "/tmp/installELK.sh"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x    /tmp/installELK.sh",
  #     "sudo sed -i -e 's/\r$//' /tmp/installELK.sh",  # Remove the spurious CR characters.
  #     "sudo /tmp/installELK.sh",
  #   ]
  # }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}


##################################################################  
#  1. Create aws_eip
##################################################################

resource "aws_eip" "ip" {
  instance = aws_instance.MyFirstInstnace.id
}


##################################################################  
#  1. Create public_ip
##################################################################

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip 
}
