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

variable "ami_id" {
  type = string
}