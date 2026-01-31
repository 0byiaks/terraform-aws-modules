# ACM Certificate
resource "aws_acm_certificate" "acm_certificate" {
  domain_name = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-acm-certificate"
   
  }
}

# Route 53 Hosted Zone
data "aws_route53_zone" "route53_zone" {
  name = var.domain_name
  private_zone = false
}

# Route 53 Record for ACM Certificate Validation
resource "aws_route53_record" "acm_certificate_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      type = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }


  allow_overwrite = true
  name = each.value.name
  type = each.value.type
  ttl = 60
  records = [each.value.record]
  zone_id = data.aws_route53_zone.route53_zone.zone_id

  depends_on = [aws_acm_certificate.acm_certificate]
}

# ACM Certificate Validation
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_certificate_validation_record : record.fqdn]
}