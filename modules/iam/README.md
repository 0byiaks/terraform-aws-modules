# IAM Module

This module creates IAM roles and instance profiles for EC2 instances with permissions to access S3 buckets and AWS Secrets Manager.

## Features

- IAM role for EC2 instances
- IAM policy with minimal permissions for S3 and Secrets Manager
- IAM instance profile for EC2
- Automatic S3 bucket name extraction from URI

## Usage

```hcl
module "iam" {
  source = "../../modules/iam"

  environment = "prod"
  project_name = "myapp"
  s3_uri = "s3://myapp-deployments/migrations/"
  secret_name = "myapp/db-credentials"
  aws_region = "us-east-1"
  aws_account_id = "123456789012"
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
| s3_uri | S3 URI for resources (e.g., s3://bucket-name/path/to/file) | `string` | n/a | yes |
| secret_name | Name of the secret in AWS Secrets Manager | `string` | n/a | yes |
| aws_region | AWS region | `string` | n/a | yes |
| aws_account_id | AWS account ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ec2_role_name | Name of the EC2 IAM role |
| ec2_instance_profile_name | Name of the EC2 instance profile |

## Resources Created

- 1 IAM Role (for EC2 service)
- 1 IAM Role Policy (S3 and Secrets Manager permissions)
- 1 IAM Instance Profile

## IAM Permissions

The IAM policy grants the following permissions:

### S3 Permissions
- `s3:GetObject` - Read objects from the specified bucket
- `s3:ListBucket` - List objects in the specified bucket

### Secrets Manager Permissions
- `secretsmanager:GetSecretValue` - Retrieve secret values
- `secretsmanager:DescribeSecret` - Describe secret metadata

## Notes

- The S3 bucket name is automatically extracted from the S3 URI
- Permissions are scoped to the specific S3 bucket and secret
- The instance profile can be attached to EC2 instances or launch templates
- The role uses the standard EC2 service trust policy

