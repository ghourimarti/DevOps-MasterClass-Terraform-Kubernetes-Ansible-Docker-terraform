module "ec2_cluster" {
    source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git"

    name    = "my-cluster"
    ami     = lookup(var.AMIS, var.aws_region) # "ami-0f40c8f97004632f9"
    instance_type          = "t2.micro"
    subnet_id   = aws_subnet.levelupvpc-private-3.id # "subnet-e92f9cc8"

    tags = {
    Terraform   = "true"
    Environment = "dev"
    }
}