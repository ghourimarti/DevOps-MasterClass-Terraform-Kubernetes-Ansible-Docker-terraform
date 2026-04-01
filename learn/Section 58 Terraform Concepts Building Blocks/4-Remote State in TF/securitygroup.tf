

######################################################
#               Resource 1 data aws_ip_ranges
######################################################

data "aws_ip_ranges" "us_east_ip_range" {
    regions = ["us-east-1"] #,"us-east-2"]
    services = ["ec2"]
}

data "aws_ip_ranges" "us_east_ip_range2" {
    services = ["ec2"]
}

######################################################
#               Resource 2 aws_security_group
######################################################

resource "aws_security_group" "sg_custom_us_east" {
    name = "custom_us_east"
    description = "Allow HTTPS from AWS EC2 IP ranges in us-east-1 and us-east-2"

    ingress {
        from_port = "443"
        to_port = "443"
        protocol = "tcp"
        cidr_blocks = slice(data.aws_ip_ranges.us_east_ip_range.cidr_blocks, 0, 50)
    }

    tags = {
        CreateDate = data.aws_ip_ranges.us_east_ip_range.create_date
        SyncToken = data.aws_ip_ranges.us_east_ip_range.sync_token
    }
}


######################################################
#               Resource 3 output
######################################################

# aws_ip_ranges
output "____________________aws_ip_ranges____________________" {
  value = {
    create_date = data.aws_ip_ranges.us_east_ip_range.create_date
    sync_token  = data.aws_ip_ranges.us_east_ip_range.sync_token
    regions  = data.aws_ip_ranges.us_east_ip_range.regions
    services  = data.aws_ip_ranges.us_east_ip_range.services
    url  = data.aws_ip_ranges.us_east_ip_range.url
    id  = data.aws_ip_ranges.us_east_ip_range.id
    # cidr_blocks = data.aws_ip_ranges.us_east_ip_range.cidr_blocks
    # ipv6_cidr_blocks = data.aws_ip_ranges.us_east_ip_range.ipv6_cidr_blocks
    # us_east_ip_range2 = data.aws_ip_ranges.us_east_ip_range2
  }
}

# 
output "____________________aws_security_group____________________" {
  value = {
    security_group_name = aws_security_group.sg_custom_us_east.name
    security_group_id   = aws_security_group.sg_custom_us_east.id
    security_group_arn  = aws_security_group.sg_custom_us_east.arn
    description         = aws_security_group.sg_custom_us_east.description
    ingress_rules       = aws_security_group.sg_custom_us_east.ingress
    egress_rules        = aws_security_group.sg_custom_us_east.egress
    region              = aws_security_group.sg_custom_us_east.region
    tags                = aws_security_group.sg_custom_us_east.tags_all
    # SECURITY_GROUP   = aws_security_group.sg_custom_us_east

  }
}