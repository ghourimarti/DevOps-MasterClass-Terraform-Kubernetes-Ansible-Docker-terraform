
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}


##################################################################  
#  1. aws_security_group:allow_elk
##################################################################

resource "aws_security_group" "allow_elk" {
  name        = "allow_elk"
  description = "All all elasticsearch traffic"

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
  availability_zone = "us-east-1"
  key_name      = aws_key_pair.levelup_key.key_name

  vpc_security_group_ids = [
    aws_security_group.allow_elk.id,
  ]

  depends_on = [aws_security_group.allow_elk]
  
  tags = {
    Name = "custom_instance"
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
