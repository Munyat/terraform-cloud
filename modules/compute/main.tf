# Determine AMI using lookup function (fallback to provided AMI if map not available)
locals {
  ami_id = var.ami != null ? var.ami : lookup(var.amis_map, var.region, var.amis_map["us-east-1"])
}

# Bastion Launch Template
resource "aws_launch_template" "bastion" {
  name_prefix   = "${var.name}-bastion-"
  image_id      = local.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.bastion_sg_id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = filebase64("${path.module}/../../user-data/bastion.sh")

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.name}-bastion"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Nginx Launch Template
resource "aws_launch_template" "nginx" {
  name_prefix   = "${var.name}-nginx-"
  image_id      = local.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.nginx_sg_id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = filebase64("${path.module}/../../user-data/nginx.sh")

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.name}-nginx"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# WordPress Launch Template
resource "aws_launch_template" "wordpress" {
  name_prefix   = "${var.name}-wordpress-"
  image_id      = local.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.webserver_sg_id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = filebase64("${path.module}/../../user-data/wordpress.sh")

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.name}-wordpress"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Tooling Launch Template
resource "aws_launch_template" "tooling" {
  name_prefix   = "${var.name}-tooling-"
  image_id      = local.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.webserver_sg_id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = filebase64("${path.module}/../../user-data/tooling.sh")

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.name}-tooling"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}