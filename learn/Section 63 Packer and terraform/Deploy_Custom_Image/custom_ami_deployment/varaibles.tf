# Variable for Create Instance Module
variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/levelup_key.pub"
}

variable "ENVIRONMENT" {
    type    = string
    default = "development"
}

variable "AMI_ID" {
    type    = string
    default = ""
}

variable "AWS_REGION" {
default = "us-east-1"
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

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


variable "PATH_TO_PRIVATE_KEY" {
  default = "levelup_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "levelup_key.pub"
}