resource "aws_instance" "MyFirstInstnac" {
  ami           = var.ami
  instance_type = "t2.micro"

  tags = {
    Name = "demoinstnce"
  }
}