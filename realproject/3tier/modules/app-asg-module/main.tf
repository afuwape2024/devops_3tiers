

resource "aws_launch_template" "web_template" {
  image_id      = var.image_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.web_security_group, var.app_sg_id]
  }

  placement {
    availability_zone = "us-east-2a"
  }

  user_data = filebase64("${path.module}/user-data.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-instance"
    }
  }
}


#======================================================================================
#======================================================================================
#======================================================================================

resource "aws_autoscaling_group" "web_scaling_group" {
  name                      = "web_scaling_group"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_type         = "EC2"
  desired_capacity          = var.desired_capacity
  force_delete              = true
 #placement_group           = aws_placement_group.test.id
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }
  health_check_grace_period = 30

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }
}

