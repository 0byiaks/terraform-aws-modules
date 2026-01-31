# VPC
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

# Public Subnets
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.public_az1.id, aws_subnet.public_2.id]
}

# Private App Subnets
output "private_app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = [aws_subnet.private_app_az1.id, aws_subnet.private_app_az2.id]
}

# Private Data Subnets
output "private_data_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = [aws_subnet.private_data_az1.id, aws_subnet.private_data_az2.id]
}

# Security Groups
output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "app_server_security_group_id" {
  description = "ID of the application server security group"
  value       = aws_security_group.app_server_sg.id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db_sg.id
}

output "dms_security_group_id" {
  description = "ID of the DMS security group"
  value       = aws_security_group.dms_sg.id
}
# NAT Gateway
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.id
}

# Ec2 Instance Connect Endpoint
output "ec2_instance_connect_endpoint_id" {
  description = "ID of the Ec2 Instance Connect Endpoint"
  value       = aws_ec2_instance_connect_endpoint.ec2_instance_connect_endpoint.id
}