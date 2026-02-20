# AMI/linux/ubuntu.pkr.hcl

# Ubuntu 22.04 LTS source
source "amazon-ebs" "ubuntu-22-04" {
  ami_name      = "${var.ami_prefix}-ubuntu-22-04-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.aws_region
  ami_regions   = var.ami_regions

  source_ami_filter {
    filters = {
      name                = var.source_ami_filters["ubuntu"].name
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = var.source_ami_filters["ubuntu"].owners
  }

  ssh_username = var.source_ami_filters["ubuntu"].user
  tags = merge(local.common_tags, {
    Name        = "${var.ami_prefix}-ubuntu-22-04"
    OS          = "Ubuntu"
    OS-Version  = "22.04"
    Build-Date  = local.timestamp
  })
}

# Ubuntu 20.04 LTS source
source "amazon-ebs" "ubuntu-20-04" {
  ami_name      = "${var.ami_prefix}-ubuntu-20-04-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.aws_region
  ami_regions   = var.ami_regions

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = "ubuntu"
  tags = merge(local.common_tags, {
    Name        = "${var.ami_prefix}-ubuntu-20-04"
    OS          = "Ubuntu"
    OS-Version  = "20.04"
    Build-Date  = local.timestamp
  })
}