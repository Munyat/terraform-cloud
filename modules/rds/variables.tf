variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "datalayer_sg_id" {
  description = "Datalayer security group ID"
  type        = string
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "appdb"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}