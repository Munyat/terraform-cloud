output "bastion_asg_name" {
  value = aws_autoscaling_group.bastion.name
}

output "nginx_asg_name" {
  value = aws_autoscaling_group.nginx.name
}

output "wordpress_asg_name" {
  value = var.create_wordpress_asg ? aws_autoscaling_group.wordpress[0].name : null
}

output "tooling_asg_name" {
  value = var.create_tooling_asg ? aws_autoscaling_group.tooling[0].name : null
}

output "sns_topic_arn" {
  value = aws_sns_topic.this.arn
}