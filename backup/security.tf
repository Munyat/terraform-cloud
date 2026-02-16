# External ALB Security Group (for external load balancer)
resource "aws_security_group" "ext-alb-sg" {
  name        = "ext-alb-sg"
  vpc_id      = aws_vpc.main.id
  description = "Security group for external ALB"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
      Name = "ext-alb-sg"
    },
  )
}

# Bastion Host Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  vpc_id      = aws_vpc.main.id
  description = "Security group for bastion host"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
      Name = "bastion-sg"
    },
  )
}

# Nginx Security Group
resource "aws_security_group" "nginx-sg" {
  name        = "nginx-sg"
  vpc_id      = aws_vpc.main.id
  description = "Security group for nginx reverse proxy"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "nginx-sg"
    },
  )
}

# Security group rule for nginx from external ALB
resource "aws_security_group_rule" "inbound-nginx-http" {
  type                     = "ingress"
  description              = "HTTP from external ALB"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ext-alb-sg.id
  security_group_id        = aws_security_group.nginx-sg.id
}

# Security group rule for nginx from bastion
resource "aws_security_group_rule" "inbound-bastion-ssh" {
  type                     = "ingress"
  description              = "SSH from bastion"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.nginx-sg.id
}

# Internal ALB Security Group
resource "aws_security_group" "int-alb-sg" {
  name        = "int-alb-sg"
  vpc_id      = aws_vpc.main.id
  description = "Security group for internal ALB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "int-alb-sg"
    },
  )
}

# Security group rule for internal ALB from nginx
resource "aws_security_group_rule" "inbound-ialb-http" {
  type                     = "ingress"
  description              = "HTTP from nginx"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nginx-sg.id
  security_group_id        = aws_security_group.int-alb-sg.id
}

# Webserver Security Group (for WordPress and Tooling)
resource "aws_security_group" "webserver-sg" {
  name        = "webserver-sg"
  vpc_id      = aws_vpc.main.id
  description = "Security group for WordPress and Tooling servers"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "webserver-sg"
    },
  )
}

# Security group rule for webservers from internal ALB
resource "aws_security_group_rule" "inbound-web-http" {
  type                     = "ingress"
  description              = "HTTP from internal ALB"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.int-alb-sg.id
  security_group_id        = aws_security_group.webserver-sg.id
}

# Security group rule for webservers from bastion
resource "aws_security_group_rule" "inbound-web-ssh" {
  type                     = "ingress"
  description              = "SSH from bastion"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.webserver-sg.id
}

# Datalayer Security Group (for EFS and RDS)
resource "aws_security_group" "datalayer-sg" {
  name        = "datalayer-sg"
  vpc_id      = aws_vpc.main.id
  description = "Security group for data layer (EFS and RDS)"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "datalayer-sg"
    },
  )
}

# Security group rule for NFS from webservers
resource "aws_security_group_rule" "inbound-nfs" {
  type                     = "ingress"
  description              = "NFS from webservers"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webserver-sg.id
  security_group_id        = aws_security_group.datalayer-sg.id
}

# Security group rule for MySQL from webservers
resource "aws_security_group_rule" "inbound-mysql-webserver" {
  type                     = "ingress"
  description              = "MySQL from webservers"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webserver-sg.id
  security_group_id        = aws_security_group.datalayer-sg.id
}

# Security group rule for MySQL from bastion
resource "aws_security_group_rule" "inbound-mysql-bastion" {
  type                     = "ingress"
  description              = "MySQL from bastion"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.datalayer-sg.id
}