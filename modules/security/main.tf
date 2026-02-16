# External ALB Security Group
resource "aws_security_group" "ext_alb_sg" {
  name        = "${var.name}-ext-alb-sg"
  description = "Security group for external ALB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_security_group_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
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
      Name = "${var.name}-ext-alb-sg"
    },
  )
}

# Bastion Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "${var.name}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.bastion_security_group_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
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
      Name = "${var.name}-bastion-sg"
    },
  )
}

# Nginx Security Group
resource "aws_security_group" "nginx_sg" {
  name        = "${var.name}-nginx-sg"
  description = "Security group for nginx reverse proxy"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-nginx-sg"
    },
  )
}

# Internal ALB Security Group
resource "aws_security_group" "int_alb_sg" {
  name        = "${var.name}-int-alb-sg"
  description = "Security group for internal ALB"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-int-alb-sg"
    },
  )
}

# Webserver Security Group
resource "aws_security_group" "webserver_sg" {
  name        = "${var.name}-webserver-sg"
  description = "Security group for web servers"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-webserver-sg"
    },
  )
}

# Datalayer Security Group
resource "aws_security_group" "datalayer_sg" {
  name        = "${var.name}-datalayer-sg"
  description = "Security group for data layer"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-datalayer-sg"
    },
  )
}

# Security Group Rules
resource "aws_security_group_rule" "nginx_from_ext_alb" {
  type                     = "ingress"
  description              = "HTTP from external ALB"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ext_alb_sg.id
  security_group_id        = aws_security_group.nginx_sg.id
}

resource "aws_security_group_rule" "nginx_from_bastion" {
  type                     = "ingress"
  description              = "SSH from bastion"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.nginx_sg.id
}

resource "aws_security_group_rule" "int_alb_from_nginx" {
  type                     = "ingress"
  description              = "HTTP from nginx"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nginx_sg.id
  security_group_id        = aws_security_group.int_alb_sg.id
}

resource "aws_security_group_rule" "webserver_from_int_alb" {
  type                     = "ingress"
  description              = "HTTP from internal ALB"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.int_alb_sg.id
  security_group_id        = aws_security_group.webserver_sg.id
}

resource "aws_security_group_rule" "webserver_from_bastion" {
  type                     = "ingress"
  description              = "SSH from bastion"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.webserver_sg.id
}

resource "aws_security_group_rule" "datalayer_nfs_from_webserver" {
  type                     = "ingress"
  description              = "NFS from webservers"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webserver_sg.id
  security_group_id        = aws_security_group.datalayer_sg.id
}

resource "aws_security_group_rule" "datalayer_mysql_from_webserver" {
  type                     = "ingress"
  description              = "MySQL from webservers"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webserver_sg.id
  security_group_id        = aws_security_group.datalayer_sg.id
}

resource "aws_security_group_rule" "datalayer_mysql_from_bastion" {
  type                     = "ingress"
  description              = "MySQL from bastion"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.datalayer_sg.id
}