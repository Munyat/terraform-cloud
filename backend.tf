# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "brian-dev-terraform-state-unique-name" # Your unique bucket name

  tags = {
    Name        = "terraform-state-bucket"
    Environment = "production"
    Managed-By  = "Terraform"
  }
}

# Separate resource for bucket versioning (new way)
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Separate resource for server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-locks-table"
    Environment = "production"
    Managed-By  = "Terraform"
  }
}