#######################################################
# 4. Create Security Group
#######################################################
# Security Group
resource "aws_security_group" "ssh" {
  name        = "${var.vpc_name}-ssh"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-ssh-sg"
  }
}