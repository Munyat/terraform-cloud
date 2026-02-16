# RDS Subnet Group - Fix naming
resource "aws_db_subnet_group" "this" {
  name       = substr(replace(lower("${var.name}-rds-subnet-group"), "/[^a-z0-9-]/", ""), 0, 255)
  subnet_ids = var.private_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-rds-subnet-group"
    },
  )
}

# RDS MySQL Instance - Fixed identifier
resource "aws_db_instance" "this" {
  # Create a valid identifier: lowercase, start with letter, no consecutive hyphens
  identifier = join("-", compact([
    lower(replace(var.name, "/[^a-z0-9]/", "")),
    "rds",
    formatdate("YYYYMMDDhhmm", timestamp())
  ]))

  allocated_storage     = 20
  storage_type          = "gp2"
  storage_encrypted     = true
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t3.micro"
  db_name               = var.db_name
  username              = var.db_username
  password              = var.db_password
  parameter_group_name  = "default.mysql5.7"
  db_subnet_group_name  = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.datalayer_sg_id]

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  skip_final_snapshot = true
  publicly_accessible = false
  multi_az           = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-rds"
    },
  )

  lifecycle {
    ignore_changes = [
      identifier,  # Ignore changes to identifier to prevent recreation
    ]
  }
}