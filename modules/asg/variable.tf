variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "app_server_security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "amazon_linux_2_ami_id" {
  description = "AMI ID for Amazon Linux 2"
  type        = string
}

variable "record_name" {
  description = "Record name"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "s3_bucket_name" {             
  description = "S3 bucket name"
  type        = string
}

variable "service_provider_file_name" {
  description = "Service provider file name"
  type        = string
}

variable "application_code_file_name" {
  description = "Application code file name"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS endpoint"
  type        = string
}

variable "rds_db_name" {
  description = "RDS database name"
  type        = string
}

variable "rds_db_username" {
  description = "RDS database username"
  type        = string
}

variable "secret_name" {
  description = "Secret name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "private_subnet_app_ids" {
  description = "List of private subnet IDs for application"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for autoscaling notifications"
  type        = string
}

 variable "ec2_role_name" {
  description = "Name of the EC2 role"
  type        = string
}