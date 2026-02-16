# Launch template for wordpress
resource "aws_launch_template" "wordpress-launch-template" {
  name_prefix   = "wordpress-lt-"
  image_id      = var.ami
  instance_type = "t2.micro"
  key_name      = var.keypair

  vpc_security_group_ids = [aws_security_group.webserver-sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ip.name
  }

  user_data = filebase64("${path.module}/user-data/wordpress.sh")

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "wordpress-instance"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group for wordpress
resource "aws_autoscaling_group" "wordpress-asg" {
  name                = "wordpress-asg"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.wordpress-tgt.arn]
  vpc_zone_identifier = [aws_subnet.private[0].id, aws_subnet.private[1].id]

  launch_template {
    id      = aws_launch_template.wordpress-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "wordpress-asg-instance"
    propagate_at_launch = true
  }
}

# Launch template for tooling
resource "aws_launch_template" "tooling-launch-template" {
  name_prefix   = "tooling-lt-"
  image_id      = var.ami
  instance_type = "t2.micro"
  key_name      = var.keypair

  vpc_security_group_ids = [aws_security_group.webserver-sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ip.name
  }

  user_data = filebase64("${path.module}/user-data/tooling.sh")

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "tooling-instance"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group for tooling
resource "aws_autoscaling_group" "tooling-asg" {
  name                = "tooling-asg"
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.tooling-tgt.arn]
  vpc_zone_identifier = [aws_subnet.private[2].id, aws_subnet.private[3].id]

  launch_template {
    id      = aws_launch_template.tooling-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "tooling-asg-instance"
    propagate_at_launch = true
  }
}