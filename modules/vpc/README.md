# VPC Module

This module creates a complete VPC infrastructure with public and private subnets across multiple availability zones, including Internet Gateway, NAT Gateway, route tables, security groups, and EC2 Instance Connect Endpoint.

## Features

- VPC with DNS support enabled
- Public subnets in 2 availability zones
- Private application subnets in 2 availability zones
- Private database subnets in 2 availability zones
- Internet Gateway for public subnet internet access
- NAT Gateway for private subnet internet access
- Route tables and associations
- Security groups for ALB, application servers, database, DMS, and EC2 Instance Connect
- EC2 Instance Connect Endpoint for secure SSH access

## Usage

```hcl
module "vpc" {
  source = "../../modules/vpc"

  environment = "prod"
  project_name = "myapp"
  vpc_cidr = "10.0.0.0/16"
  public_subnet_az1_cidr = "10.0.1.0/24"
  public_subnet_az2_cidr = "10.0.2.0/24"
  private_subnet_app_az1_cidr = "10.0.11.0/24"
  private_subnet_app_az2_cidr = "10.0.12.0/24"
  private_subnet_data_az1_cidr = "10.0.21.0/24"
  private_subnet_data_az2_cidr = "10.0.22.0/24"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| environment | Environment name (e.g., dev, staging, prod) | `string` | n/a | yes |
| project_name | Name of the project | `string` | n/a | yes |
| vpc_cidr | CIDR block for the VPC | `string` | n/a | yes |
| public_subnet_az1_cidr | CIDR block for public subnet in AZ1 | `string` | n/a | yes |
| public_subnet_az2_cidr | CIDR block for public subnet in AZ2 | `string` | n/a | yes |
| private_subnet_app_az1_cidr | CIDR block for private subnet in AZ1 for application | `string` | n/a | yes |
| private_subnet_app_az2_cidr | CIDR block for private subnet in AZ2 for application | `string` | n/a | yes |
| private_subnet_data_az1_cidr | CIDR block for private subnet in AZ1 for database | `string` | n/a | yes |
| private_subnet_data_az2_cidr | CIDR block for private subnet in AZ2 for database | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| public_subnet_ids | List of public subnet IDs |
| private_app_subnet_ids | List of private application subnet IDs |
| private_data_subnet_ids | List of private database subnet IDs |
| alb_security_group_id | ID of the ALB security group |
| app_server_security_group_id | ID of the application server security group |
| db_security_group_id | ID of the database security group |
| dms_security_group_id | ID of the DMS security group |
| nat_gateway_id | ID of the NAT Gateway |
| ec2_instance_connect_endpoint_id | ID of the EC2 Instance Connect Endpoint |

## Resources Created

- 1 VPC
- 2 Public Subnets
- 2 Private Application Subnets
- 2 Private Database Subnets
- 1 Internet Gateway
- 1 NAT Gateway
- 1 Elastic IP for NAT Gateway
- 2 Route Tables (public and private)
- 6 Route Table Associations
- 4 Security Groups (ALB, App Server, Database, DMS, EC2 Instance Connect)
- 1 EC2 Instance Connect Endpoint

## Notes

- The NAT Gateway is placed in the first public subnet (AZ1)
- All security groups are pre-configured with appropriate ingress/egress rules
- The EC2 Instance Connect Endpoint allows secure SSH access without public IPs or bastion hosts

