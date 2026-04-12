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



resource "aws_launch_template" "levelup-launchtemplate" {
  name_prefix   = "levelup-launchtemplate"

  image_id      = lookup(var.AMIS, var.aws_region)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name
  
  vpc_security_group_ids = [aws_security_group.levelup-instance.id]

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
  # vpc_zone_identifier       = ["subnet-9e0ad9f5", "subnet-d7a6afad"]
  # launch_configuration      = aws_launch_configuration.levelup-launchconfig.name
  launch_template {
    id      = aws_launch_template.levelup-launchtemplate.id
    version = "$Latest"
  }
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 200

  ##
  # health_check_type         = "EC2"
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.levelup-elb.name]


  force_delete              = trueyes

  tag {
    key                 = "Name"
    value               = "LevelUp Custom EC2 instance"
    propagate_at_launch = true
  }
}







#################################################
#  3. Autoscaling Configuration policy
#################################################
# Autoscaling Configuration policy - Scaling Alarm
resource "aws_autoscaling_policy" "levelup-cpu-policy" {
  name                   = "levelup-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}

#################################################
#  4. Auto scaling Monitoring: 
#################################################
# Auto scaling Cloud Watch Monitoring
resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm" {
  alarm_name          = "levelup-cpu-alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.levelup-cpu-policy.arn]
}

#################################################
#  5. Auto Descaling Configuration Policy
#################################################
# Auto Descaling Policy
resource "aws_autoscaling_policy" "levelup-cpu-policy-scaledown" {
  name                   = "levelup-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}

#################################################
#  6.  Auto Descaling Monitoring:
#################################################
# Auto descaling cloud watch 
resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm-scaledown" {
  alarm_name          = "levelup-cpu-alarm-scaledown"
  alarm_description   = "Alarm once CPU Uses Decrease"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.levelup-cpu-policy-scaledown.arn]
}


# 🔄 Full Execution Flow (Step-by-Step)
# Step 1: Metrics
# Each EC2 sends:
# CPUUtilization → CloudWatch

# Step 2: Aggregation
# Every 120 sec:
# Compute average CPU across ASG

# Step 3: Condition Check
# Is CPU ≤ 10%?

# Step 4: Stability Check
# Has this been true for 2 periods?
# (= 4 minutes)

# Step 5: Alarm Fires
# State = ALARM

# Step 6: Action Triggered
# Execute scaling policy

# Step 7: ASG Executes
# Remove 1 EC2 instance