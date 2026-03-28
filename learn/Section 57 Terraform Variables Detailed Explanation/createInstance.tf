
resource "aws_instance" "MyFirstInstnace" {
  ami           = "ami-02633e712f6dcb86f"
  instance_type = "t2.micro"

  tags = {
    Name = "demoinstnce"
  }
}