# EC2 Migrate Module

This module creates an EC2 instance specifically for running database migrations using Flyway. The instance automatically runs migrations and terminates after completion.

## Features

- EC2 instance for database migrations
- Automatic Flyway installation and execution
- Integration with AWS Secrets Manager for database credentials
- S3 integration for migration scripts
- Automatic instance termination after migration

## Usage

```hcl
module "ec2-migrate" {
  source = "../../modules/ec2-migrate"

  environment = "prod"
  project_name = "myapp"
  instance_type = "t3.micro"
  amazon_linux_2_ami_id = "ami-0c55b159cbfafe1f0"
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  dms_security_group_id = module.vpc.dms_security_group_id
  ec2_role_name = module.iam.ec2_instance_profile_name
  db_endpoint = module.rds.db_endpoint
  rds_db_name = module.rds.db_name
  rds_db_username = module.secrets-manager.username
  s3_uri = "s3://myapp-deployments/migrations/"
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
| amazon_linux_2_ami_id | AMI ID for Amazon Linux 2 | `string` | n/a | yes |
| private_app_subnet_ids | List of private app subnet IDs | `list(string)` | n/a | yes |
| dms_security_group_id | Security group ID for the migration instance | `string` | n/a | yes |
| ec2_role_name | IAM instance profile name for the EC2 instance | `string` | n/a | yes |
| db_endpoint | RDS database endpoint | `string` | n/a | yes |
| rds_db_name | RDS database name | `string` | n/a | yes |
| rds_db_username | RDS database username | `string` | n/a | yes |
| s3_uri | S3 URI for the migration SQL scripts (directory or file) | `string` | n/a | yes |
| secret_name | Name of the secret in AWS Secrets Manager | `string` | n/a | yes |
| aws_region | AWS region | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| migrate_instance_id | ID of the migration EC2 instance |
| migrate_instance_arn | ARN of the migration EC2 instance |
| migrate_instance_private_ip | Private IP address of the migration EC2 instance |

## Resources Created

- 1 EC2 Instance

## Files

- `db-migrate-script.sh` - User data script that:
  - Installs jq for JSON parsing
  - Retrieves database credentials from AWS Secrets Manager
  - Downloads and installs Flyway
  - Downloads migration SQL scripts from S3
  - Runs Flyway migrations
  - Terminates the instance after 7 minutes

## Migration Scripts

Migration SQL scripts should be stored in S3 at the path specified by `s3_uri`. The scripts should follow Flyway naming conventions (e.g., `V1__Create_users_table.sql`).

## Notes

- The instance automatically terminates 7 minutes after migration completion
- Flyway version is hardcoded to 11.15.0 in the script
- The instance requires IAM permissions for S3 and Secrets Manager (use the IAM module)
- Migration logs are written to `/var/log/migration-script.log`
- The script uses MySQL JDBC driver (configured for MySQL databases)
- Ensure the security group allows outbound traffic to S3 and Secrets Manager

