#################################################
#  1. IAM Users
#################################################
# TF File for IAM Users and Groups

resource "aws_iam_user" "adminuser1" {
  name = "kinza" # "adminuser1"
}

resource "aws_iam_user" "adminuser2" {
  name = "hania" # "adminuser2"
}

#################################################
#  2. IAM Groups
#################################################
# 1. Group TF Definition
resource "aws_iam_group" "admingroup" {
  name = "zohee" #"admingroup"
}

# 2. Assign User to AWS Group
resource "aws_iam_group_membership" "admin-users" {
  name = "admin-users"
  users = [
    aws_iam_user.adminuser1.name,
    aws_iam_user.adminuser2.name,
  ]
  group = aws_iam_group.admingroup.name
}

#################################################
#  3. Individual Policies
#################################################
# Policy for AWS Group
# resource "aws_iam_policy_attachment" "admin-users-attach" {
#   name       = "admin-users-attach"
#   groups     = [aws_iam_group.admingroup.name]
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

resource "aws_iam_policy_attachment" "vpc" {
  name       = "vpc-users-attach"
  groups     = [aws_iam_group.admingroup.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_policy_attachment" "ec2-users-attach" {
  name       = "ec2-users-attach"
  groups     = [aws_iam_group.admingroup.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_policy_attachment" "s3-users-attach" {
  name       = "s3-users-attach"
  groups     = [aws_iam_group.admingroup.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


#################################################
#  3. Group Policies
#################################################
