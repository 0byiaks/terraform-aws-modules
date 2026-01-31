# ASG Module

This module creates an Auto Scaling Group (ASG) with launch template, target group attachment, and SNS notifications for autoscaling events.

## Features

- Launch template with user data script for application deployment
- Auto Scaling Group with configurable min/max/desired capacity
- Integration with ALB target group
- SNS notifications for autoscaling events
- CloudWatch monitoring enabled

## Usage

```hcl
module "asg" {
  source = "../../modules/asg"

  environment = "prod"
  project_name = "myapp"
  instance_type = "t3.medium"
  app_server_security_group_id = module.vpc.app_server_security_group_id
  amazon_linux_2_ami_id = "ami-0c55b159cbfafe1f0"
  ec2_role_name = module.iam.ec2_instance_profile_name
  private_subnet_app_ids = module.vpc.private_app_subnet_ids
  alb_target_group_arn = module.alb.alb_target_group_arn
  sns_topic_arn = module.route53.sns_topic_arn
  
  # Application configuration
  record_name = "api"
  domain_name = "example.com"
  s3_bucket_name = "myapp-deployments"
  service_provider_file_name = "AppServiceProvider"
  application_code_file_name = "app-code"
  
  # Database configuration
  rds_endpoint = module.rds.db_endpoint
  rds_db_name = module.rds.db_name
  rds_db_username = "admin"
  secret_name = "myapp/db-credentials"
  aws_region = "us-east-1"
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
| environment | Environment name | `string` | n/a | yes |
| project_name | Project name | `string` | n/a | yes |
| instance_type | EC2 instance type | `string` | n/a | yes |
| app_server_security_group_id | Security group ID for application servers | `string` | n/a | yes |
| amazon_linux_2_ami_id | AMI ID for Amazon Linux 2 | `string` | n/a | yes |
| ec2_role_name | Name of the IAM instance profile for EC2 | `string` | n/a | yes |
| private_subnet_app_ids | List of private subnet IDs for application servers | `list(string)` | n/a | yes |
| alb_target_group_arn | ARN of the ALB target group | `string` | n/a | yes |
| sns_topic_arn | ARN of the SNS topic for autoscaling notifications | `string` | n/a | yes |
| record_name | Subdomain record name | `string` | n/a | yes |
| domain_name | Domain name | `string` | n/a | yes |
| s3_bucket_name | S3 bucket name containing application code | `string` | n/a | yes |
| service_provider_file_name | Service provider file name in S3 | `string` | n/a | yes |
| application_code_file_name | Application code file name in S3 (without .zip extension) | `string` | n/a | yes |
| rds_endpoint | RDS database endpoint | `string` | n/a | yes |
| rds_db_name | RDS database name | `string` | n/a | yes |
| rds_db_username | RDS database username | `string` | n/a | yes |
| secret_name | Name of the secret in AWS Secrets Manager | `string` | n/a | yes |
| aws_region | AWS region | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| asg_name | Name of the Auto Scaling Group |
| asg_arn | ARN of the Auto Scaling Group |
| asg_id | ID of the Auto Scaling Group |

## Resources Created

- 1 Launch Template
- 1 Auto Scaling Group
- 1 Auto Scaling Attachment (to ALB target group)
- 1 Auto Scaling Notification (SNS)

## Files

- `deployment script.sh` - User data script that:
  - Retrieves secrets from AWS Secrets Manager
  - Installs PHP 8 and Apache
  - Downloads and deploys application code from S3
  - Configures environment variables
  - Starts Apache service

## Notes

- Default ASG configuration: min=1, max=2, desired=1
- Health check type is ELB
- Launch template uses latest version automatically
- User data script expects application code as a zip file in S3
- The deployment script configures a PHP application (Laravel-compatible)

