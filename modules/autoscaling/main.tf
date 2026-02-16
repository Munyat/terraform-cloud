# SNS Topic
resource "aws_sns_topic" "this" {
  name = "${var.name}-asg-notifications"
}

# Auto Scaling Group for Bastion
resource "aws_autoscaling_group" "bastion" {
  name                = "${var.name}-bastion-asg"
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = var.bastion_target_group_arns

  min_size         = var.bastion_min_size
  max_size         = var.bastion_max_size
  desired_capacity = var.bastion_desired_capacity

  health_check_type         = var.bastion_health_check_type
  health_check_grace_period = var.health_check_grace_period

  launch_template {
    id      = var.bastion_launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-bastion-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

# Auto Scaling Group for Nginx
resource "aws_autoscaling_group" "nginx" {
  name                = "${var.name}-nginx-asg"
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = var.nginx_target_group_arns

  min_size         = var.nginx_min_size
  max_size         = var.nginx_max_size
  desired_capacity = var.nginx_desired_capacity

  health_check_type         = var.nginx_health_check_type
  health_check_grace_period = var.health_check_grace_period

  launch_template {
    id      = var.nginx_launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-nginx-asg"
    propagate_at_launch = true
  }
}

# Auto Scaling Group for WordPress (with conditional expression)
resource "aws_autoscaling_group" "wordpress" {
  # Conditional count - only create if enabled
  count = var.create_wordpress_asg ? 1 : 0

  name                = "${var.name}-wordpress-asg"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = var.wordpress_target_group_arns

  # Conditional min/max/desired based on environment
  min_size         = var.environment == "production" ? var.wordpress_min_size : 1
  max_size         = var.environment == "production" ? var.wordpress_max_size : 2
  desired_capacity = var.environment == "production" ? var.wordpress_desired_capacity : 1

  health_check_type         = var.wordpress_health_check_type
  health_check_grace_period = var.health_check_grace_period

  launch_template {
    id      = var.wordpress_launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-wordpress-asg"
    propagate_at_launch = true
  }
}

# Auto Scaling Group for Tooling (with conditional expression)
resource "aws_autoscaling_group" "tooling" {
  # Conditional count - only create if enabled
  count = var.create_tooling_asg ? 1 : 0

  name                = "${var.name}-tooling-asg"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = var.tooling_target_group_arns

  # Conditional using ternary operator
  min_size         = var.create_tooling_asg ? var.tooling_min_size : 0
  max_size         = var.create_tooling_asg ? var.tooling_max_size : 0
  desired_capacity = var.create_tooling_asg ? var.tooling_desired_capacity : 0

  health_check_type         = var.tooling_health_check_type
  health_check_grace_period = var.health_check_grace_period

  launch_template {
    id      = var.tooling_launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-tooling-asg"
    propagate_at_launch = true
  }
}

# Auto Scaling Notifications
resource "aws_autoscaling_notification" "this" {
  group_names = compact([
    aws_autoscaling_group.bastion.name,
    aws_autoscaling_group.nginx.name,
    var.create_wordpress_asg ? aws_autoscaling_group.wordpress[0].name : "",
    var.create_tooling_asg ? aws_autoscaling_group.tooling[0].name : "",
  ])

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.this.arn
}