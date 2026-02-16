output "bastion_launch_template_id" {
  value = aws_launch_template.bastion.id
}

output "nginx_launch_template_id" {
  value = aws_launch_template.nginx.id
}

output "wordpress_launch_template_id" {
  value = aws_launch_template.wordpress.id
}

output "tooling_launch_template_id" {
  value = aws_launch_template.tooling.id
}

output "bastion_launch_template_latest_version" {
  value = aws_launch_template.bastion.latest_version
}

output "nginx_launch_template_latest_version" {
  value = aws_launch_template.nginx.latest_version
}

output "wordpress_launch_template_latest_version" {
  value = aws_launch_template.wordpress.latest_version
}

output "tooling_launch_template_latest_version" {
  value = aws_launch_template.tooling.latest_version
}