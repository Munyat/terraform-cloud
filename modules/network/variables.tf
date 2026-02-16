variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "enable_dns_support" {
  description = "Enable DNS support in VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in VPC"
  type        = bool
  default     = true
}

variable "preferred_number_of_public_subnets" {
  description = "Number of public subnets"
  type        = number
}

variable "preferred_number_of_private_subnets" {
  description = "Number of private subnets"
  type        = number
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}