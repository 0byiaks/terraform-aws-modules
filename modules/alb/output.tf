output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_alb.load_balancer.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_alb.load_balancer.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = aws_alb.load_balancer.zone_id
}

output "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_alb_target_group.alb_target_group.arn
}

output "alb_listener_arn" {
  description = "ARN of the ALB HTTPS listener"
  value       = aws_alb_listener.alb_listener_https.arn
}

output "alb_listener_http_arn" {
  description = "ARN of the ALB HTTP listener (redirect)"
  value       = aws_alb_listener.alb_listener.arn
}