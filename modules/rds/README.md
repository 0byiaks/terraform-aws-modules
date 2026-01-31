# RDS Module

This module creates an RDS database instance with subnet group, security group configuration, and secrets management integration.

## Features

- RDS database instance with configurable engine and version
- Database subnet group across multiple availability zones
- Integration with AWS Secrets Manager for credentials
- Multi-AZ deployment option
- Automatic availability zone selection

## Usage

```hcl
module "rds" {
  source = "../../modules/rds"

  environment = "prod"
  project_name = "myapp"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.medium"
  allocated_storage = 20
  multi_az_deployment = true
  db_security_group_id = module.vpc.db_security_group_id
  database_subnet_ids = module.vpc.private_data_subnet_ids
  secrets_json = module.secrets-manager.secrets_json
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
| engine | Database engine (mysql, postgres, etc.) | `string` | n/a | yes |
| engine_version | Engine version | `string` | n/a | yes |
| instance_class | RDS instance class | `string` | n/a | yes |
| allocated_storage | Allocated storage in GB | `number` | n/a | yes |
| multi_az_deployment | Enable Multi-AZ deployment | `bool` | n/a | yes |
| db_security_group_id | Security group ID for the database | `string` | n/a | yes |
| database_subnet_ids | List of database subnet IDs | `list(string)` | n/a | yes |
| secrets_json | JSON string of secrets from Secrets Manager (must contain username, password, dbname) | `string` | n/a | yes (sensitive) |

## Outputs

| Name | Description |
|------|-------------|
| db_endpoint | RDS instance endpoint |
| db_name | RDS database name |

## Resources Created

- 1 RDS Database Instance
- 1 DB Subnet Group

## Secrets Format

The `secrets_json` variable must be a JSON string with the following structure:

```json
{
  "username": "admin",
  "password": "secure-password",
  "dbname": "mydatabase"
}
```

## Notes

- Database is not publicly accessible
- Final snapshot is skipped (set to true)
- Storage type is gp2
- Availability zone is automatically selected from available zones
- Secrets are parsed from JSON and used for database credentials
- It's recommended to use the secrets-manager module to retrieve secrets

