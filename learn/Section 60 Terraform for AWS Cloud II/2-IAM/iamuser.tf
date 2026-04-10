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

##########################################################
#  3. Individual Policies (aws_iam_user_policy_attachment)
##########################################################
# Policy for AWS Group

resource "aws_iam_user_policy_attachment" "kinza_vpc" {
  user       = aws_iam_user.adminuser1.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_user_policy_attachment" "hania_vpc" {
  user       = aws_iam_user.adminuser2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}


#################################################
#  3. Group Policies (aws_iam_group_policy_attachment)
#################################################

# resource "aws_iam_group_policy_attachment" "vpc" {
#   group      = aws_iam_group.admingroup.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
# }

resource "aws_iam_group_policy_attachment" "group_ec2" {
  group      = aws_iam_group.admingroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# resource "aws_iam_group_policy_attachment" "s3" {
#   group      = aws_iam_group.admingroup.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }


# #################################################
# #  3. Group Policies (aws_iam_policy_attachment)
# #################################################

resource "aws_iam_policy_attachment" "s3-attach" {
  name       = "s3-users-attach"
  groups     = [aws_iam_group.admingroup.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}



