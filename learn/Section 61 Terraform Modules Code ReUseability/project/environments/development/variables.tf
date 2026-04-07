variable "aws_access_key" {
  type      = string
  sensitive = true
  default = ""
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}

# variable "instance_ami" {
#   type    = string
#   default = "ami-02633e712f6dcb86f"
# }

# variable "instance_type" {
#   type    = string
#   default = "t2.nano"
# }