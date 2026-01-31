variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "dms_security_group_id" {
  description = "Security group ID for the EC2 instance"
  type        = string
}

variable "db_endpoint" {
  description = "Endpoint of the database"
  type        = string
}

variable "rds_db_name" {
  description = "Name of the database"
  type        = string
}

variable "amazon_linux_2_ami_id" {
  description = "AMI ID for Amazon Linux 2"
  type        = string
}

variable "private_app_subnet_ids" {
  description = "List of private app subnet IDs"
  type        = list(string)
}

variable "ec2_role_name" {
  description = "IAM instance profile name for the EC2 instance"
  type        = string
}

variable "rds_db_username" {
  description = "RDS database username"
  type        = string
}

variable "s3_uri" {
  description = "S3 URI for the migration SQL script"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "secret_name" {
  description = "Name of the secret in AWS Secrets Manager"
  type        = string
}

