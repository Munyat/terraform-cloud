variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "ami" {
  description = "AMI ID (will be looked up from map if not provided)"
  type        = string
  default     = null
}

variable "amis_map" {
  description = "Map of AMIs by region"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "bastion_sg_id" {
  description = "Bastion security group ID"
  type        = string
}

variable "nginx_sg_id" {
  description = "Nginx security group ID"
  type        = string
}

variable "webserver_sg_id" {
  description = "Webserver security group ID"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}