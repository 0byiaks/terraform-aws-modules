# ALB
resource "aws_alb" "load_balancer" {
  name = "${var.environment}-${var.project_name}-alb"
  internal = false
  load_balancer_type = var.load_balancer_type
  subnets = var.public_subnet_ids
  security_groups = [var.alb_security_group_id]
  tags = {
    Name = "${var.environment}-${var.project_name}-alb"
  }
}

# ALB Target Group
resource "aws_alb_target_group" "alb_target_group" {
  name = "${var.environment}-${var.project_name}-alb-target-group"
  port = 80
  target_type = var.target_type
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check { 
    path = var.health_check_path
    port = "traffic-port"
    protocol = "HTTP"
    matcher = "200,301,302"
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 10
    interval = 30
  }
  tags = {
    Name = "${var.environment}-${var.project_name}-alb-target-group"
  }
}

# ALB HTTP to HTTPS Redirect
resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.load_balancer.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ALB HTTPS Listener
resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn = aws_alb.load_balancer.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate_arn
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
}