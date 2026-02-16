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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}