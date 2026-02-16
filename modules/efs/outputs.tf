output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "efs_dns_name" {
  value = aws_efs_file_system.this.dns_name
}

output "wordpress_access_point_id" {
  value = aws_efs_access_point.wordpress.id
}

output "tooling_access_point_id" {
  value = aws_efs_access_point.tooling.id
}