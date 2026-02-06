variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}  

variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
variable "load_balancer_type" {
  description = "Type of the load balancer"
  type        = string
}

variable "target_type" {
  description = "Type of the instance"
  type        = string
}

variable "health_check_path" {
  description = "Path for the health check"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the certificate"
  type        = string
}