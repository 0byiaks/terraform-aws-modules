variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "zone_id" {
  description = "Zone ID"
  type        = string
}   

variable "record_name" {
  description = "Record name"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID of the ALB"
  type        = string
}

variable "operator_email" {
  description = "Email address of the operator"
  type        = string
}