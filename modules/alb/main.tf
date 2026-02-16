# External ALB
resource "aws_lb" "external" {
  name               = "${var.name}-ext-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ext_alb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-ext-alb"
    },
  )
}

# External ALB Target Group for Nginx
resource "aws_lb_target_group" "nginx" {
  name     = "${var.name}-nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-nginx-tg"
    },
  )
}

# External ALB Listener
resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.external.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-nginx-listener"
    },
  )
}

# Internal ALB
resource "aws_lb" "internal" {
  name               = "${var.name}-int-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.int_alb_sg_id]
  subnets            = var.private_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-int-alb"
    },
  )
}

# Internal ALB Target Group for WordPress
resource "aws_lb_target_group" "wordpress" {
  name     = "${var.name}-wp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-wp-tg"
    },
  )
}

# Internal ALB Target Group for Tooling
resource "aws_lb_target_group" "tooling" {
  name     = "${var.name}-tooling-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-tooling-tg"
    },
  )
}

# Internal ALB Listener
resource "aws_lb_listener" "internal" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress.arn
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-int-listener"
    },
  )
}

# Listener Rule for Tooling
resource "aws_lb_listener_rule" "tooling" {
  listener_arn = aws_lb_listener.internal.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tooling.arn
  }

  condition {
    path_pattern {
      values = ["/tooling*"]
    }
  }
}