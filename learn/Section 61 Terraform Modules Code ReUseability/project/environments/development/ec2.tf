resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file("../../keys/levelup_key.pub")
}

resource "aws_instance" "dev_server" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = module.dev_vpc.public_subnet_ids[0]
  vpc_security_group_ids = [module.dev_vpc.ssh_security_group_id]
  key_name               = aws_key_pair.levelup_key.key_name

  tags = {
    Name        = "dev-server"
    Environment = "Development"
  }
}