# ECR Module

This module creates an Amazon ECR (Elastic Container Registry) repository for storing Docker container images.

## Features

- ECR repository with configurable naming
- Image tag mutability (MUTABLE by default)
- Automatic image scanning on push
- Proper tagging for resource management

## Usage

```hcl
module "ecr" {
  source = "../../modules/ecr"

  environment = "prod"
  project_name = "myapp"
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

## Outputs

| Name | Description |
|------|-------------|
| ecr_repository_name | The name of the ECR repository |
| ecr_repository_arn | The ARN of the ECR repository |
| ecr_repository_url | The URL of the ECR repository (for docker push/pull) |

## Resources Created

- 1 ECR Repository
- Image scanning configuration (scan on push enabled)
- Image tag mutability set to MUTABLE

## Notes

- Image tag mutability is set to MUTABLE (allows overwriting tags)
- Image scanning on push is enabled by default for security
- The repository URL can be used for docker push/pull commands
- Repository name follows the pattern: `{environment}-{project_name}-ecr-repository`

## Example: Using ECR with Docker

After creating the repository, you can push images:

```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Build and tag your image
docker build -t myapp:latest .
docker tag myapp:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/prod-myapp-ecr-repository:latest

# Push to ECR
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/prod-myapp-ecr-repository:latest
```

