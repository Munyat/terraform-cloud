# KMS Key for EFS encryption
resource "aws_kms_key" "efs" {
  description             = "KMS key for EFS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-efs-kms"
    },
  )
}

# KMS Key Alias
resource "aws_kms_alias" "efs" {
  name          = "alias/${var.name}-efs"
  target_key_id = aws_kms_key.efs.key_id
}

# Elastic File System
resource "aws_efs_file_system" "this" {
  creation_token   = "${var.name}-efs"
  encrypted        = true
  kms_key_id       = aws_kms_key.efs.arn
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-efs"
    },
  )
}

# Mount targets for EFS (in private subnets)
resource "aws_efs_mount_target" "this" {
  count = length(var.private_subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.private_subnet_ids[count.index]
  security_groups = [var.datalayer_sg_id]
}

# Access point for WordPress
resource "aws_efs_access_point" "wordpress" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    gid = 33 # www-data group
    uid = 33 # www-data user
  }

  root_directory {
    path = "/wordpress"

    creation_info {
      owner_gid   = 33
      owner_uid   = 33
      permissions = "0755"
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-wordpress-ap"
    },
  )
}

# Access point for Tooling
resource "aws_efs_access_point" "tooling" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    gid = 33
    uid = 33
  }

  root_directory {
    path = "/tooling"

    creation_info {
      owner_gid   = 33
      owner_uid   = 33
      permissions = "0755"
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-tooling-ap"
    },
  )
}