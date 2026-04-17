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

clear ; terraform destroy ; echo "<----------------------- init --------------------------->" ; terraform init ; echo "<------------------------- plan ------------------------->" ; terraform plan ; echo "<---------------------------- apply ---------------------->" ; terraform apply; echo "<-------------------------------------------------->" ;

clear ; git add . ; git commit -m "pull ... " ; git push

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

ssh -i levelup_key ubuntu@
ec2-54-175-74-216.compute-1.amazonaws.com

# got to EC2 --> Network and security --> Security Groups
# --> Edit inbound Rules --> 
# you Linux machine (digital ocean or Virtual box machine) IP

# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html?finding-an-ami-aws-cli

# find the 

############################################################
#      S59 Terraform Concepts - Building Blocks
############################################################

ssh-keygen -f levelup_key

ssh -i levelup_key ubuntu@ec2-54-175-74-216.compute-1.amazonaws.com

sudo -s
df -h
mkfs.ext4 <device_name>   # device_name = /dev/xvdh
mkfs.ext4 /dev/xvdh
# 
mkdir -p /data

#
mount <device_name> /data  # device_name = /dev/xvdh
mount /dev/xvdh /data
##########
sudo -s
df -h
mkfs.ext4 /dev/xvdh
mkdir -p /data
mount /dev/xvdh /data

# but mount will remove when instance reboot 
# for that permanent mount
vim /etc/fstab
/dev/xvdh /data ext4 defaults 0 0 



############################################################
#      S60 RDS
############################################################


sudo apt-get install mysql-client
mysql -u root -h "mariadb.cs922k48e3e5.us-east-1.rds.amazonaws.com -p'mariadb141'"



apt-get install python3-pip python3-dev

echo "tehsafDdkfdjfffffffffffffffffffffffffffffffdfkdfd fgsg" >> terra.txt
apt install -y awscli

aws s3 cp terra.txt s3://zohee-levelup-bucket141

sudo -s

apt-get update  ;  apt-get install stress  ; sudo apt install stress-ng -y 
stress --cpu 2 --timeout 900



############################################################
#      S63 Packer 
############################################################
packer Validate
packer Build
Save Atifacts
Use Artifacts further in terraform


https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html
https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#AMICatalog



packer validate scenario2.json 
packer build scenario2.json 



############################################################
#      Section 65: Job Scenario 2 : Terraform Docker and Kubernetes
############################################################
terraform plan
terraform apply # comment out intance creation for vpc, subnet
# get vpc id, subnet id from aws cloud
packer validate install_custom_ami.json
packer build install_custom_ami.json
# get the ami id and paste into the terrform variabels.tf file
# UN comment out intance creation for vpc, subnet
terraform plan
terraform apply

# now ssh the created instance
apt list --installed
apt list --installed | grep nginx
apt list --installed | grep docker



############################################################
#     Section 66: Job Scenario 3 : Terraform & AWS ELK
############################################################
# first create VPC, subnet and securtiy using AWS console, AWS CLI, cloud formation
aws eks create-cluster 
    --name levelup-eks 
    --region us-east-2 
    --role-arn arn:aws:iam::164435161465:role/AWSEKS 
    --resources-vpc-config subnetIds=subnet-0a472d7fc289f93d1, \
                            subnet-0a78ec2c78371e4b1, \
                            subnet-0544480e573fdd660, \
                            subnet-0466f3e84ef0eaf82, \
                            securityGroupIds=sg-0b5c6ef65c5b0b89d