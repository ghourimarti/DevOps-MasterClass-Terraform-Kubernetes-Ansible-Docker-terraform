############################################################

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest


# 0. 
Write IaC

# 1. 
terraform init

# 2.
terraform plan
terraform plan -out plan.out

# 3. Deploy
terraform apply
terraform apply plan.out

# 4.
terraform destroy

############################################################
#      S55 IaC with Terraform
############################################################

# Install Terrraform


############################################################
#      S56 Start with Terraform Basics
############################################################


clear ; git add . ; git commit -m "v1 ... " ; git push
clear ; git pull

echo "<-------------------------------------------------->" ; terraform init ; echo "<-------------------------------------------------->" ; terraform plan ; echo "<-------------------------------------------------->" ; terraform apply; echo "<-------------------------------------------------->" ;


# Provide Creds in Env Variables
export AWS_ACCESS_KEY_ID=""  
export AWS_SECRET_ACCESS_KEY=""  
export AWS_DEFAULT_REGION=""  

ssh root@143.244.137.104
ZA152024in

############################################################
#      S58 Terraform Concepts - Building Blocks
############################################################

ssh-keygen -f levelup_key

ssh -i levelup_key ubuntu@ec2-54-175-74-216.compute-1.amazonaws.com

# got to EC2 --> Network and security --> Security Groups
# --> Edit inbound Rules --> 
# you Linux machine (digital ocean or Virtual box machine) IP

# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html?finding-an-ami-aws-cli

