variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  default     = "production"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "bastion_launch_template_id" {
  description = "Bastion launch template ID"
  type        = string
}

variable "nginx_launch_template_id" {
  description = "Nginx launch template ID"
  type        = string
}

variable "wordpress_launch_template_id" {
  description = "WordPress launch template ID"
  type        = string
}

variable "tooling_launch_template_id" {
  description = "Tooling launch template ID"
  type        = string
}

variable "bastion_target_group_arns" {
  description = "Bastion target group ARNs"
  type        = list(string)
  default     = []
}

variable "nginx_target_group_arns" {
  description = "Nginx target group ARNs"
  type        = list(string)
  default     = []
}

variable "wordpress_target_group_arns" {
  description = "WordPress target group ARNs"
  type        = list(string)
  default     = []
}

variable "tooling_target_group_arns" {
  description = "Tooling target group ARNs"
  type        = list(string)
  default     = []
}

variable "bastion_min_size" {
  description = "Bastion ASG minimum size"
  type        = number
  default     = 1
}

variable "bastion_max_size" {
  description = "Bastion ASG maximum size"
  type        = number
  default     = 2
}

variable "bastion_desired_capacity" {
  description = "Bastion ASG desired capacity"
  type        = number
  default     = 1
}

variable "bastion_health_check_type" {
  description = "Bastion ASG health check type"
  type        = string
  default     = "EC2"
}

variable "nginx_min_size" {
  description = "Nginx ASG minimum size"
  type        = number
  default     = 1
}

variable "nginx_max_size" {
  description = "Nginx ASG maximum size"
  type        = number
  default     = 3
}

variable "nginx_desired_capacity" {
  description = "Nginx ASG desired capacity"
  type        = number
  default     = 2
}

variable "nginx_health_check_type" {
  description = "Nginx ASG health check type"
  type        = string
  default     = "ELB"
}

variable "wordpress_min_size" {
  description = "WordPress ASG minimum size"
  type        = number
  default     = 1
}

variable "wordpress_max_size" {
  description = "WordPress ASG maximum size"
  type        = number
  default     = 3
}

variable "wordpress_desired_capacity" {
  description = "WordPress ASG desired capacity"
  type        = number
  default     = 2
}

variable "wordpress_health_check_type" {
  description = "WordPress ASG health check type"
  type        = string
  default     = "ELB"
}

variable "tooling_min_size" {
  description = "Tooling ASG minimum size"
  type        = number
  default     = 1
}

variable "tooling_max_size" {
  description = "Tooling ASG maximum size"
  type        = number
  default     = 2
}

variable "tooling_desired_capacity" {
  description = "Tooling ASG desired capacity"
  type        = number
  default     = 1
}

variable "tooling_health_check_type" {
  description = "Tooling ASG health check type"
  type        = string
  default     = "ELB"
}

variable "health_check_grace_period" {
  description = "Health check grace period"
  type        = number
  default     = 300
}

variable "create_wordpress_asg" {
  description = "Whether to create WordPress ASG"
  type        = bool
  default     = true
}

variable "create_tooling_asg" {
  description = "Whether to create Tooling ASG"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}