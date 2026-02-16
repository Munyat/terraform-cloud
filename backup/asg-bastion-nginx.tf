# Random shuffle for AZs
resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = length(data.aws_availability_zones.available.names)
}

# SNS Topic for notifications
resource "aws_sns_topic" "acs-sns" {
  name = "Default_CloudWatch_Alarms_Topic"
}

# Launch template for bastion
resource "aws_launch_template" "bastion-launch-template" {
  name_prefix   = "bastion-lt-"
  image_id      = var.ami
  instance_type = "t2.micro"
  key_name      = var.keypair

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ip.name
  }

  user_data = filebase64("${path.module}/user-data/bastion.sh")

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "bastion-instance"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group for bastion
resource "aws_autoscaling_group" "bastion-asg" {
  name                = "bastion-asg"
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  health_check_type   = "EC2"
  vpc_zone_identifier = [aws_subnet.public[0].id, aws_subnet.public[1].id]

  launch_template {
    id      = aws_launch_template.bastion-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "bastion-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "production"
    propagate_at_launch = true
  }
}

# Launch template for nginx
resource "aws_launch_template" "nginx-launch-template" {
  name_prefix   = "nginx-lt-"
  image_id      = var.ami
  instance_type = "t2.micro"
  key_name      = var.keypair

  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ip.name
  }

  user_data = filebase64("${path.module}/user-data/nginx.sh")

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "nginx-instance"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group for nginx
resource "aws_autoscaling_group" "nginx-asg" {
  name                = "nginx-asg"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.nginx-tgt.arn]
  vpc_zone_identifier = [aws_subnet.public[0].id, aws_subnet.public[1].id]

  launch_template {
    id      = aws_launch_template.nginx-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "nginx-asg-instance"
    propagate_at_launch = true
  }
}