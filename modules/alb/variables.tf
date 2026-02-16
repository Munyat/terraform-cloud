variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "ext_alb_sg_id" {
  description = "External ALB security group ID"
  type        = string
}

variable "int_alb_sg_id" {
  description = "Internal ALB security group ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}