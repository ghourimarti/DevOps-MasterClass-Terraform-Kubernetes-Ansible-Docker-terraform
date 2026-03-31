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


git add . ; git commit -m "v1 ... " ; git push


# Provide Creds in Env Variables
export AWS_ACCESS_KEY_ID=""  
export AWS_SECRET_ACCESS_KEY=""  
export AWS_DEFAULT_REGION=""  

ssh root@143.244.137.104

############################################################
#      S58 Terraform Concepts - Building Blocks
############################################################

ssh-keygen -f levelup_key



