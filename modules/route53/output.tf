output "site_record_name" {
  description = "Name of the site record"
  value       = aws_route53_record.site_record.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.sns_topic.arn
}
