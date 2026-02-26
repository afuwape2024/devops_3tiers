#Need to create load balancer seperate security group for load balancer for health-check reason

resource "aws_security_group" "load_balancer_security_group" {
  name        = "load_balancer_security_group"
  description = "Allow HTTP from Internet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "load_balancer_security_group"
  }
}

#======================================================================================
#======================================================================================
#create target group first before load balancer

resource "aws_lb_target_group" "web_target_group" {
  name_prefix = "webtg-"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.web_target_group
  }
}

#======================================================================================
#======================================================================================

resource "aws_lb" "application_lb" {
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_security_group.id]
  subnets            = var.web_subnet_ids

  tags = {
    Environment = "application_lb"
  }
}


resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}