output "migrate_instance_id" {
  description = "ID of the migration EC2 instance"
  value       = aws_instance.data-migrate-instance.id
}

output "migrate_instance_arn" {
  description = "ARN of the migration EC2 instance"
  value       = aws_instance.data-migrate-instance.arn
}

output "migrate_instance_private_ip" {
  description = "Private IP address of the migration EC2 instance"
  value       = aws_instance.data-migrate-instance.private_ip
}

