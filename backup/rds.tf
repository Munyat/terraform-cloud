# RDS Subnet Group
resource "aws_db_subnet_group" "ACS-rds" {
  name       = "acs-rds-subnet-group"
  subnet_ids = [aws_subnet.private[2].id, aws_subnet.private[3].id]

  tags = merge(
    var.tags,
    {
      Name = "ACS-rds-subnet-group"
    }
  )
}

# RDS Security Group
resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from webserver security group"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver-sg.id]
  }

  ingress {
    description     = "MySQL from bastion security group"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "rds-security-group"
    }
  )
}

# RDS MySQL Instance
resource "aws_db_instance" "ACS-rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = "acsdb"
  username               = var.master-username
  password               = var.master-password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.ACS-rds.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false # Set to true for production

  tags = merge(
    var.tags,
    {
      Name = "ACS-rds-instance"
    }
  )
}