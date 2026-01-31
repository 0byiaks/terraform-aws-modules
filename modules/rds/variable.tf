variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "db_security_group_id" {
  description = "Security group ID for the database"
  type        = string
}

variable "engine" {
  description = "Engine for the database"
  type        = string
}

variable "engine_version" {
  description = "Engine version for the database"
  type        = string
}

variable "instance_class" {
  description = "Instance class for the database"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage for the database"
  type        = number
}
variable "multi_az_deployment" {
  description = "Multi-AZ for the database"
  type        = bool
}

variable "secrets_json" {
  description = "JSON string of secrets from Secrets Manager"
  type        = string
  sensitive   = true
}

variable "database_subnet_ids" {
  description = "List of database subnet IDs (us-east-1a and us-east-1b)"
  type        = list(string)
}