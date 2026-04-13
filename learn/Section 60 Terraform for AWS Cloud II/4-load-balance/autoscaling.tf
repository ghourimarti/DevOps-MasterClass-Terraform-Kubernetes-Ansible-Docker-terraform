#################################################
#  0. Generate Key
#################################################
# Generate Key
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#################################################
#  1. Configuration: 
#################################################


# AutoScaling Launch Configuration
# HOW to create EC2
# resource "aws_launch_configuration" "levelup-launchconfig" {
#   name_prefix     = "levelup-launchconfig"
#   image_id        = lookup(var.AMIS, var.aws_region)
#   instance_type   = "t2.micro"
#   key_name        = aws_key_pair.levelup_key.key_name

#   ###### 
#   security_groups = [aws_security_group.levelup-instance.id]
#   user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"

#   lifecycle {
#     create_before_destroy = true
#   }

# }

#################################################

resource "aws_launch_template" "levelup-launchtemplate" {
  name_prefix   = "levelup-launchtemplate"

  image_id      = lookup(var.AMIS, var.aws_region)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name
  monitoring {
    enabled = true
  }
  
  vpc_security_group_ids = [aws_security_group.levelup-instance.id]
  user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "LevelUp EC2"
    }
  }
}


#################################################
#  2. Autoscaling Group:
#################################################
# Autoscaling Group
# HOW MANY EC2 to run
resource "aws_autoscaling_group" "levelup-autoscaling" {
  name                      = "levelup-autoscaling"
  vpc_zone_identifier = [
    aws_subnet.levelupvpc-public-1.id,
    aws_subnet.levelupvpc-public-2.id
    ]
  # launch_configuration      = aws_launch_configuration.levelup-launchconfig.name
  launch_template {
    id      = aws_launch_template.levelup-launchtemplate.id
    version = "$Latest"
  }
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 200
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.levelup-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "LevelUp Custom EC2 instance"
    propagate_at_launch = true
  }
}



#################################################
#  3. Output:
#################################################
output "ELB" {
  value = aws_elb.levelup-elb.dns_name
}