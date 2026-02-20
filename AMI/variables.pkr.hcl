# AMI/variables.pkr.hcl
variable "aws_region" {
  description = "AWS region to build AMI in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for building AMI"
  type        = string
  default     = "t2.micro"
}

variable "ami_prefix" {
  description = "Prefix for AMI names"
  type        = string
  default     = "custom"
}

variable "ami_regions" {
  description = "Regions to distribute AMI to"
  type        = list(string)
  default     = ["us-east-1", "us-east-2"]
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "production"
}

variable "source_ami_filters" {
  description = "Source AMI filters for different OS types"
  type = map(object({
    name   = string
    owners = list(string)
    user   = string
  }))
  default = {
    ubuntu = {
      name   = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      owners = ["099720109477"]
      user   = "ubuntu"
    }
    amazon-linux = {
      name   = "amzn2-ami-hvm-*-x86_64-ebs"
      owners = ["amazon"]
      user   = "ec2-user"
    }
  }
}