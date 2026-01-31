# Secrets Manager Module

This module retrieves and parses secrets from AWS Secrets Manager. It acts as a data source module to fetch and expose secret values for use in other modules.

## Features

- Retrieves secrets from AWS Secrets Manager
- Parses JSON secret strings
- Exposes individual secret values as outputs
- Sensitive output handling

## Usage

```hcl
module "secrets-manager" {
  source = "../../modules/secrets-manager"

  secret_name = "myapp/db-credentials"
}
```

Then use the outputs in other modules:

```hcl
module "rds" {
  source = "../../modules/rds"
  # ... other variables
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
| secret_name | Name of the secret in AWS Secrets Manager | `string` | n/a | yes |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| secrets | All secrets parsed from JSON as a map | yes |
| secrets_json | Raw JSON string from Secrets Manager | yes |
| username | Username from secrets | yes |
| password | Password from secrets | yes |
| db_name | Database name from secrets | yes |

## Expected Secret Format

The secret in AWS Secrets Manager should be stored as a JSON string with the following structure:

```json
{
  "username": "admin",
  "password": "secure-password",
  "dbname": "mydatabase"
}
```

## Resources Created

- No resources are created (data sources only)

## Notes

- This module only reads secrets; it does not create them
- All outputs are marked as sensitive
- The secret must exist in AWS Secrets Manager before using this module
- The module expects the secret to be in JSON format
- Individual secret values (username, password, db_name) are extracted for convenience

