# ASG Launch Template
resource "aws_launch_template" "asg_launch_template" {
  name = "${var.environment}-${var.project_name}-asg-launch-template"
  image_id = var.amazon_linux_2_ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.app_server_security_group_id]
  iam_instance_profile {
    name = var.ec2_role_name
  }
  tags = {
    Name = "${var.environment}-${var.project_name}-asg-launch-template"
  }

  monitoring {
    enabled = true
  }

  user_data = base64encode(templatefile("${path.module}/deployment script.sh", {
    ENVIRONMENT = var.environment
    PROJECT_NAME = var.project_name
    RECORD_NAME = var.record_name
    DOMAIN_NAME = var.domain_name
    S3_BUCKET_NAME = var.s3_bucket_name
    SERVICE_PROVIDER_FILE_NAME = var.service_provider_file_name
    APPLICATION_CODE_FILE_NAME = var.application_code_file_name
    RDS_ENDPOINT = var.rds_endpoint
    RDS_DB_NAME = var.rds_db_name
    RDS_DB_USERNAME = var.rds_db_username
    SECRET_NAME = var.secret_name
    AWS_REGION = var.aws_region
  }))
}

# Auto Scaling Group for the application server
resource "aws_autoscaling_group" "asg" {
  name = "${var.environment}-${var.project_name}-asg"
  launch_template {
    id = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }
  min_size = 1
  max_size = 2
  desired_capacity = 1
  
  vpc_zone_identifier = var.private_subnet_app_ids
  target_group_arns   = [var.alb_target_group_arn]
  health_check_type   = "ELB"
  
  tag {
    key                 = "Name"
    value               = "${var.environment}-${var.project_name}-webserver"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [target_group_arns]
    create_before_destroy = true
  }

}

# Attach autoscaling group to the ALB target group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn = var.alb_target_group_arn
  depends_on = [aws_autoscaling_group.asg]
}

# SNS notification for the autoscaling events
resource "aws_autoscaling_notification" "webserver_asg_notification" {
  group_names = [aws_autoscaling_group.asg.name]
  
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH", 
    "autoscaling:EC2_INSTANCE_TERMINATE", 
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR", 
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
   ]
  topic_arn = var.sns_topic_arn
  depends_on = [aws_autoscaling_group.asg]
}