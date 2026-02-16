output "external_alb_dns" {
  value = aws_lb.external.dns_name
}

output "external_alb_arn" {
  value = aws_lb.external.arn
}

output "internal_alb_dns" {
  value = aws_lb.internal.dns_name
}

output "nginx_target_group_arn" {
  value = aws_lb_target_group.nginx.arn
}

output "wordpress_target_group_arn" {
  value = aws_lb_target_group.wordpress.arn
}

output "tooling_target_group_arn" {
  value = aws_lb_target_group.tooling.arn
}