# ACM Module

This module creates an ACM (AWS Certificate Manager) certificate with DNS validation using Route53 records.

## Features

- ACM certificate with domain and wildcard subdomain
- Automatic DNS validation via Route53
- Certificate validation resource

## Usage

```hcl
module "acm" {
  source = "../../modules/acm"

  environment = "prod"
  project_name = "myapp"
  domain_name = "example.com"
}
```

**Note:** This module requires an existing Route53 hosted zone for the domain.

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
| domain_name | Domain name for the certificate (must have existing Route53 hosted zone) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| acm_certificate_arn | ARN of the ACM certificate |

## Resources Created

- 1 ACM Certificate (with domain and wildcard subdomain)
- Route53 validation records (created automatically)
- 1 ACM Certificate Validation resource

## Notes

- The module automatically creates DNS validation records in Route53
- Includes both the domain and wildcard subdomain (*.domain.com)
- Certificate validation method is DNS
- Requires an existing Route53 hosted zone for the domain
- The certificate will be validated automatically once DNS records are created

