# External Application Load Balancer
resource "aws_lb" "ext-alb" {
  name               = "ext-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ext-alb-sg.id]
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]

  enable_deletion_protection = false

  tags = merge(
    var.tags,
    {
      Name = "ACS-ext-alb"
    },
  )
}

# Target group for nginx
resource "aws_lb_target_group" "nginx-tgt" {
  name     = "nginx-tgt"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    var.tags,
    {
      Name = "ACS-nginx-tgt"
    },
  )
}

# Listener for external ALB
resource "aws_lb_listener" "nginx-listener" {
  load_balancer_arn = aws_lb.ext-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tgt.arn
  }

  tags = merge(
    var.tags,
    {
      Name = "ACS-nginx-listener"
    },
  )
}

# Internal Application Load Balancer
resource "aws_lb" "ialb" {
  name               = "ialb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.int-alb-sg.id]
  subnets            = [aws_subnet.private[0].id, aws_subnet.private[1].id]

  enable_deletion_protection = false

  tags = merge(
    var.tags,
    {
      Name = "ACS-int-alb"
    },
  )
}

# Target group for wordpress
resource "aws_lb_target_group" "wordpress-tgt" {
  name     = "wordpress-tgt"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    var.tags,
    {
      Name = "ACS-wordpress-tgt"
    },
  )
}

# Target group for tooling
resource "aws_lb_target_group" "tooling-tgt" {
  name     = "tooling-tgt"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    var.tags,
    {
      Name = "ACS-tooling-tgt"
    },
  )
}

# Listener for internal ALB
resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.ialb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tgt.arn
  }

  tags = merge(
    var.tags,
    {
      Name = "ACS-web-listener"
    },
  )
}

# Listener rule for tooling
resource "aws_lb_listener_rule" "tooling-listener" {
  listener_arn = aws_lb_listener.web-listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tooling-tgt.arn
  }

  condition {
    host_header {
      values = ["briancheruiyot.publicvm.com"]
    }
  }
}