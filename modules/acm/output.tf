output "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.acm_certificate.arn
}

output "domain_name" {
  description = "Domain name used for the ACM certificate"
  value       = var.domain_name
}
