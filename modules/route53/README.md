# Route53 Module

This module creates Route53 DNS records and SNS topic with email subscription for notifications.

## Features

- Route53 A record with ALB alias
- SNS topic for notifications
- Email subscription to SNS topic

## Usage

```hcl
module "route53" {
  source = "../../modules/route53"

  environment = "prod"
  project_name = "myapp"
  zone_id = "Z1234567890ABC"  # Route53 hosted zone ID
  record_name = "api"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id = module.alb.alb_zone_id
  operator_email = "admin@example.com"
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
| zone_id | Route53 hosted zone ID | `string` | n/a | yes |
| record_name | DNS record name (subdomain) | `string` | n/a | yes |
| alb_dns_name | DNS name of the ALB | `string` | n/a | yes |
| alb_zone_id | Zone ID of the ALB | `string` | n/a | yes |
| operator_email | Email address for SNS notifications | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| site_record_name | Name of the Route53 record |
| sns_topic_arn | ARN of the SNS topic |

## Resources Created

- 1 Route53 A Record (alias to ALB)
- 1 SNS Topic
- 1 SNS Topic Subscription (email)

## Notes

- The Route53 record is an alias record pointing to the ALB
- Target health evaluation is enabled for the alias record
- Email subscription requires confirmation via email before receiving notifications
- SNS topic can be used for autoscaling notifications and other alerts

