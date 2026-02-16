# KMS Key for EFS encryption
resource "aws_kms_key" "ACS-kms" {
  description             = "KMS key for EFS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    var.tags,
    {
      Name = "ACS-kms-key"
    }
  )
}

# KMS Key Alias
resource "aws_kms_alias" "alias" {
  name          = "alias/ACS-kms"
  target_key_id = aws_kms_key.ACS-kms.key_id
}

# Elastic File System
resource "aws_efs_file_system" "ACS-efs" {
  creation_token   = "ACS-efs"
  encrypted        = true
  kms_key_id       = aws_kms_key.ACS-kms.arn
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  tags = merge(
    var.tags,
    {
      Name = "ACS-efs"
    }
  )
}

# Mount targets for EFS
resource "aws_efs_mount_target" "subnet-1" {
  file_system_id  = aws_efs_file_system.ACS-efs.id
  subnet_id       = aws_subnet.private[0].id
  security_groups = [aws_security_group.datalayer-sg.id]
}

resource "aws_efs_mount_target" "subnet-2" {
  file_system_id  = aws_efs_file_system.ACS-efs.id
  subnet_id       = aws_subnet.private[1].id
  security_groups = [aws_security_group.datalayer-sg.id]
}

# Access point for wordpress
resource "aws_efs_access_point" "wordpress" {
  file_system_id = aws_efs_file_system.ACS-efs.id

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
      Name = "wordpress-access-point"
    }
  )
}

# Access point for tooling
resource "aws_efs_access_point" "tooling" {
  file_system_id = aws_efs_file_system.ACS-efs.id

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
      Name = "tooling-access-point"
    }
  )
}