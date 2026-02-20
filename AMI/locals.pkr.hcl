
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  
  common_tags = {
    Environment = var.environment
    Managed-By  = "Packer"
    Created     = local.timestamp
  }
}