# Terraform AWS Modules Registry

A collection of reusable, production-ready Terraform modules for AWS infrastructure. These modules are designed to be self-contained, well-documented, and follow Terraform best practices for use across multiple projects.

## 📦 Modules

| Module | Description | Documentation |
|--------|-------------|---------------|
| [VPC](./modules/vpc/README.md) | Complete VPC infrastructure with public/private subnets, NAT Gateway, security groups, and EC2 Instance Connect | [View](./modules/vpc/README.md) |
| [ALB](./modules/alb/README.md) | Application Load Balancer with HTTP to HTTPS redirect and target group | [View](./modules/alb/README.md) |
| [ASG](./modules/asg/README.md) | Auto Scaling Group with launch template and SNS notifications | [View](./modules/asg/README.md) |
| [RDS](./modules/rds/README.md) | RDS database instance with subnet group and secrets integration | [View](./modules/rds/README.md) |
| [ACM](./modules/acm/README.md) | ACM certificate with DNS validation via Route53 | [View](./modules/acm/README.md) |
| [Route53](./modules/route53/README.md) | Route53 DNS records and SNS topic for notifications | [View](./modules/route53/README.md) |
| [IAM](./modules/iam/README.md) | IAM roles and instance profiles for EC2 with S3 and Secrets Manager access | [View](./modules/iam/README.md) |
| [Secrets Manager](./modules/secrets-manager/README.md) | Data source module for retrieving secrets from AWS Secrets Manager | [View](./modules/secrets-manager/README.md) |
| [EC2 Migrate](./modules/ec2-migrate/README.md) | EC2 instance for running database migrations using Flyway | [View](./modules/ec2-migrate/README.md) |

## 🚀 Quick Start

### Using Local Path

```hcl
module "vpc" {
  source = "./modules/vpc"
  
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

### Using Git Repository

```hcl
module "vpc" {
  source = "git::https://github.com/yourorg/terraform-aws-modules.git//modules/vpc?ref=v1.0.0"
  
  environment = "prod"
  project_name = "myapp"
  # ... other variables
}
```

### Using Terraform Registry (if published)

```hcl
module "vpc" {
  source = "yourorg/vpc/aws"
  version = "1.0.0"
  
  environment = "prod"
  project_name = "myapp"
  # ... other variables
}
```

## 📋 Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## 🏗️ Architecture Example

A typical infrastructure stack using these modules:

```
┌─────────────────────────────────────────────────────────┐
│                      Route53 + ACM                       │
│              (DNS + SSL Certificate)                      │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│                      ALB Module                          │
│            (Application Load Balancer)                  │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│                      ASG Module                          │
│         (Auto Scaling Group + EC2 Instances)            │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│                      RDS Module                          │
│                    (Database)                            │
└──────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                      VPC Module                          │
│    (Network, Subnets, Security Groups, NAT Gateway)      │
└──────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│              IAM + Secrets Manager Modules               │
│         (Permissions + Credential Management)            │
└──────────────────────────────────────────────────────────┘
```

## 📝 Module Dependencies

Understanding module dependencies helps in planning your infrastructure:

- **VPC** - Foundation module, typically created first
- **IAM** - Required before creating EC2 instances (ASG, EC2-migrate)
- **Secrets Manager** - Required before RDS (for database credentials)
- **ACM** - Required before ALB (for SSL certificate)
- **RDS** - Can be created after VPC and Secrets Manager
- **ALB** - Requires VPC and ACM
- **ASG** - Requires VPC, IAM, ALB, RDS, and Secrets Manager
- **Route53** - Requires ALB (for DNS records)
- **EC2-migrate** - Requires VPC, IAM, RDS, and Secrets Manager

## 🔧 Usage Example

Complete example using multiple modules:

```hcl
# 1. VPC (Foundation)
module "vpc" {
  source = "./modules/vpc"
  # ... variables
}

# 2. IAM Roles
module "iam" {
  source = "./modules/iam"
  # ... variables
}

# 3. Secrets Manager
module "secrets-manager" {
  source = "./modules/secrets-manager"
  secret_name = "myapp/db-credentials"
}

# 4. RDS Database
module "rds" {
  source = "./modules/rds"
  db_security_group_id = module.vpc.db_security_group_id
  database_subnet_ids = module.vpc.private_data_subnet_ids
  secrets_json = module.secrets-manager.secrets_json
  # ... other variables
}

# 5. ACM Certificate
module "acm" {
  source = "./modules/acm"
  domain_name = "example.com"
  # ... variables
}

# 6. Application Load Balancer
module "alb" {
  source = "./modules/alb"
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_security_group_id = module.vpc.alb_security_group_id
  vpc_id = module.vpc.vpc_id
  certificate_arn = module.acm.acm_certificate_arn
  # ... other variables
}

# 7. Route53 and SNS
module "route53" {
  source = "./modules/route53"
  zone_id = "Z1234567890ABC"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id = module.alb.alb_zone_id
  # ... other variables
}

# 8. Auto Scaling Group
module "asg" {
  source = "./modules/asg"
  private_subnet_app_ids = module.vpc.private_app_subnet_ids
  app_server_security_group_id = module.vpc.app_server_security_group_id
  ec2_role_name = module.iam.ec2_instance_profile_name
  alb_target_group_arn = module.alb.alb_target_group_arn
  sns_topic_arn = module.route53.sns_topic_arn
  rds_endpoint = module.rds.db_endpoint
  rds_db_name = module.rds.db_name
  # ... other variables
}
```

## 🎯 Best Practices

1. **Version Pinning**: Always pin module versions when using Git sources
   ```hcl
   source = "git::https://...?ref=v1.0.0"
   ```

2. **Environment Variables**: Use consistent naming for `environment` and `project_name` across all modules

3. **Secrets Management**: Always use the Secrets Manager module for sensitive data instead of hardcoding credentials

4. **Tagging**: All resources are automatically tagged with `environment` and `project_name` for cost tracking and resource management

5. **State Management**: Use remote state backends (S3, Terraform Cloud) for production environments

6. **Module Testing**: Test modules in a development environment before deploying to production

## 📚 Module Structure

Each module follows a consistent structure:

```
modules/
  └── module-name/
      ├── main.tf          # Main resource definitions
      ├── variables.tf     # Input variables
      ├── output.tf        # Output values
      ├── README.md        # Module documentation
      └── [scripts/]       # Optional script files
```

## 🔒 Security Considerations

- All modules use security groups with least-privilege principles
- Database instances are not publicly accessible
- IAM roles follow the principle of least privilege
- Secrets are never hardcoded; use Secrets Manager module
- EC2 instances in private subnets with NAT Gateway for updates

## 🤝 Contributing

When adding new modules or modifying existing ones:

1. Ensure modules are self-contained
2. Add comprehensive README.md documentation
3. Include usage examples
4. Follow existing naming conventions
5. Test modules thoroughly before committing

## 📄 License

[Specify your license here]

## 📞 Support

For issues, questions, or contributions, please [create an issue](link-to-issues) or contact the infrastructure team.

## 🔄 Versioning

Modules follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality in a backward-compatible manner
- **PATCH** version for backward-compatible bug fixes

## 📊 Module Status

| Module | Status | Version |
|--------|--------|---------|
| VPC | ✅ Stable | 1.0.0 |
| ALB | ✅ Stable | 1.0.0 |
| ASG | ✅ Stable | 1.0.0 |
| RDS | ✅ Stable | 1.0.0 |
| ACM | ✅ Stable | 1.0.0 |
| Route53 | ✅ Stable | 1.0.0 |
| IAM | ✅ Stable | 1.0.0 |
| Secrets Manager | ✅ Stable | 1.0.0 |
| EC2 Migrate | ✅ Stable | 1.0.0 |

