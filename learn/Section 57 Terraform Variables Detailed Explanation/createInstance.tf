
resource "aws_instance" "MyFirstInstnace" {
  ami           = var.ami
  instance_type = "t2.micro"

  tags = {
    Name = "demoinstnce"
  }
}