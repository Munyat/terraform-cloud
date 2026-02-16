variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The VPC CIDR block"
  type        = string
  default     = "172.16.0.0/16"
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

variable "enable_classiclink" {
  description = "Enable ClassicLink"
  type        = bool
  default     = false
}

variable "enable_classiclink_dns_support" {
  description = "Enable ClassicLink DNS support"
  type        = bool
  default     = false
}

variable "preferred_number_of_public_subnets" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

variable "preferred_number_of_private_subnets" {
  description = "Number of private subnets"
  type        = number
  default     = 4
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "ACS"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)

  default = {
    Environment     = "production"
    Owner-Email     = "briankipkiruimunyat@gmail.com"
    Managed-By      = "Terraform"
    Billing-Account = "1234567890"
  }
}

variable "amis" {
  description = "Map of AMI IDs by region"
  type        = map(string)
  default = {
    eu-central-1 = "ami-0b0af3577fe5e3532" # Ubuntu 20.04 in Frankfurt
    us-east-1    = "ami-0c7217cdde317cfec" # Ubuntu 20.04 in Virginia
    us-west-1    = "ami-0f562d4b341f5b5d8" # Ubuntu 20.04 in N. California
    eu-west-1    = "ami-04893cdc0c903a531" # Ubuntu 20.04 in Ireland
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "keypair" {
  description = "Key pair for SSH access"
  type        = string
  default     = "devops"
}

variable "master-username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "master-password" {
  description = "RDS master password"
  type        = string
  default     = "Password123"
  sensitive   = true
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "appdb"
}

variable "create_wordpress_asg" {
  description = "Whether to create WordPress Auto Scaling Group"
  type        = bool
  default     = true
}

variable "create_tooling_asg" {
  description = "Whether to create Tooling Auto Scaling Group"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  default     = "production"
}