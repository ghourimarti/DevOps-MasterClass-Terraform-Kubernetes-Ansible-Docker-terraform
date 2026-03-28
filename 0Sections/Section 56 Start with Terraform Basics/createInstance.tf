
# resource "aws_instance" "MyFirstInstnace" {
#   ami           = "ami-05692172625678b4e"
#   instance_type = "t2.micro"
# }


############################################################
#      Mine
############################################################

# Configure the AWS Provider

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

# 
resource "aws_instance" "MyFirstInstnace" {
  ami           = "ami-02633e712f6dcb86f"
  instance_type = "t2.micro"
}
