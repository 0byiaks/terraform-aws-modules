# Database Endpoint
output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.db_instance.endpoint
}
# RDS database name
output "db_name" {
  description = "RDS database name"
  value       = aws_db_instance.db_instance.db_name
}