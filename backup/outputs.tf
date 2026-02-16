# Backend Outputs
output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}

# Network Outputs
output "vpc_id" {
  value       = module.network.vpc_id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = module.network.public_subnet_ids
  description = "Public Subnet IDs"
}

output "private_subnet_ids" {
  value       = module.network.private_subnet_ids
  description = "Private Subnet IDs"
}

# ALB Outputs
output "external_alb_dns" {
  value       = module.alb.external_alb_dns
  description = "External ALB DNS Name"
}

output "internal_alb_dns" {
  value       = module.alb.internal_alb_dns
  description = "Internal ALB DNS Name"
}

# EFS Outputs
output "efs_id" {
  value       = module.efs.efs_id
  description = "EFS File System ID"
}

# RDS Outputs
output "rds_endpoint" {
  value       = module.rds.rds_endpoint
  description = "RDS Endpoint"
  sensitive   = true
}

# Auto Scaling Outputs
output "bastion_asg_name" {
  value       = module.autoscaling.bastion_asg_name
  description = "Bastion Auto Scaling Group Name"
}

output "nginx_asg_name" {
  value       = module.autoscaling.nginx_asg_name
  description = "Nginx Auto Scaling Group Name"
}