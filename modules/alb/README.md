# ALB Module

This module creates an Application Load Balancer (ALB) with HTTP to HTTPS redirect, HTTPS listener, and target group configuration.

## Features

- Application Load Balancer in public subnets
- HTTP listener with automatic redirect to HTTPS
- HTTPS listener with SSL certificate
- Target group with configurable health checks
- Support for both instance and IP target types

## Usage

```hcl
module "alb" {
  source = "../../modules/alb"

  environment = "prod"
  project_name = "myapp"
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_security_group_id = module.vpc.alb_security_group_id
  vpc_id = module.vpc.vpc_id
  load_balancer_type = "application"
  instance_type = "instance"
  health_check_path = "/health"
  certificate_arn = module.acm.acm_certificate_arn
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
| public_subnet_ids | List of public subnet IDs where ALB will be deployed | `list(string)` | n/a | yes |
| alb_security_group_id | Security group ID for the ALB | `string` | n/a | yes |
| vpc_id | ID of the VPC | `string` | n/a | yes |
| load_balancer_type | Type of load balancer (application, network, gateway) | `string` | n/a | yes |
| instance_type | Target type (instance, ip, lambda, alb) | `string` | n/a | yes |
| health_check_path | Path for the health check | `string` | n/a | yes |
| certificate_arn | ARN of the SSL certificate from ACM | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| alb_arn | ARN of the Application Load Balancer |
| alb_dns_name | DNS name of the ALB |
| alb_zone_id | Zone ID of the ALB (for Route53 alias records) |
| alb_target_group_arn | ARN of the ALB target group |
| alb_listener_arn | ARN of the ALB HTTPS listener |
| alb_listener_http_arn | ARN of the ALB HTTP listener (redirect) |

## Resources Created

- 1 Application Load Balancer
- 1 Target Group
- 2 Listeners (HTTP redirect and HTTPS)

## Notes

- HTTP traffic is automatically redirected to HTTPS
- Health check is configured with matcher codes 200, 301, 302
- SSL policy is set to ELBSecurityPolicy-2016-08
- Target group uses HTTP protocol on port 80

