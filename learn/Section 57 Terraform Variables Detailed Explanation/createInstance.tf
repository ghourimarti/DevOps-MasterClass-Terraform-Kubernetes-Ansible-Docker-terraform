
resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.aws_region)
  instance_type = "t2.micro"

  tags = {
    Name = "demoinstnce"
  }

  # security_groups = var.Security_Group
}