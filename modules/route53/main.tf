# SNS Topic
resource "aws_sns_topic" "sns_topic" {
  name = "${var.environment}-${var.project_name}-sns-topic"
  tags = {
    Name = "${var.environment}-${var.project_name}-sns-topic"
  }
}
# Email Subscription
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol = "email"
  endpoint = var.operator_email
  
}

# Route 53 Record
resource "aws_route53_record" "site_record" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = "A"
  
  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }
}