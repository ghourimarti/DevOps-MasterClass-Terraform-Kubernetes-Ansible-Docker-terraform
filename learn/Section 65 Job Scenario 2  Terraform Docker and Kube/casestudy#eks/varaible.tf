variable "cluster-name" {
  default = "levelup-tf-eks-demo"
  type    = string
}

variable "ENVIRONMENT" {
    type    = string
    default = "development"
}

variable "AMIS" {
    type = map
    default = {
        us-east-1 = "ami-02633e712f6dcb86f"
        us-east-2 = "ami-05692172625678b4e"
        us-west-2 = "ami-02c8896b265d8c480"
        eu-west-1 = "ami-0cdd3aca00188622e"
    }
}

variable "AWS_REGION" {
default = "us-east-1"
}

variable "aws_region" {
  type = string
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
