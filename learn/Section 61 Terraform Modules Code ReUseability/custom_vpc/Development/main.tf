module "dev-vpc" {
    source                          = "../../custom_vpc"
    aws_secret_key                  = var.aws_secret_key
    vpcname                         = "dev01-vpc"
    cidr                            = "10.0.0.0/16"
    enable_dns_support              = true
    # enable_classiclink              = "false"
    # enable_classiclink_dns_support  = "false"
    enable_ipv6                     = "true"
    vpcenvironment                  = "Development-Engineering"
}

