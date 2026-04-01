

######################################################
#               Resource 1 data aws_ip_ranges
######################################################

data "aws_ip_ranges" "us_east_ip_range" {
    regions = ["us-east-1","us-east-2"]
    services = ["ec2"]
}


######################################################
#               Resource 2 aws_security_group
######################################################

resource "aws_security_group" "sg-custom_us_east" {
    name = "custom_us_east"

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
#               Resource 3output
######################################################

output "all_cidr_blocks" {
  value = data.aws_ip_ranges.us_east_ip_range.cidr_blocks
}

output "first_10_cidr_blocks" {
  value = slice(
    data.aws_ip_ranges.us_east_ip_range.cidr_blocks,
    0,
    10
  )
}

output "first_cidr_block" {
  value = data.aws_ip_ranges.us_east_ip_range.cidr_blocks[0]
}

output "metadata" {
  value = {
    create_date = data.aws_ip_ranges.us_east_ip_range.create_date
    sync_token  = data.aws_ip_ranges.us_east_ip_range.sync_token
  }
}