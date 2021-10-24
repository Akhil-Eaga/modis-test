variable "region" {
  type = string
}
variable "whitelist" {
  type = list(string)
}

variable "apache_web_server_image_id" {
  type = string
}

variable "apache_web_server_instance_type" {
  type = string
}

variable "apache_web_server_desired_capacity" {
  type = number
}

variable "apache_web_server_max_size" {
  type = number
}

variable "apache_web_server_min_size" {
  type = number
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "ap-southeast-2a"
  tags = {
    "Terraform" = "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "ap-southeast-2b"
  tags = {
    "Terraform" = "true"
  }
}

resource "aws_default_subnet" "default_az3" {
  availability_zone = "ap-southeast-2c"
  tags = {
    "Terraform" = "true"
  }
}

resource "aws_security_group" "apache_prod_web" {
  name        = "apache_prod_web"
  description = "Allow standard http and https inbound and everything outbound"

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.whitelist
  }

  tags = {
    "Terraform" = "true"
  }
}

resource "aws_elb" "apache_prod_web" {
  name            = "apache-prod-web"
  subnets         = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, aws_default_subnet.default_az3.id]
  security_groups = [aws_security_group.apache_prod_web.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  tags = {
    "Terraform" = "true"
  }
}

resource "aws_launch_template" "apache_prod_web" {
  name_prefix            = "apache-prod-web"
  image_id               = var.apache_web_server_image_id
  instance_type          = var.apache_web_server_instance_type
  user_data              = filebase64("install_apache.sh")
  vpc_security_group_ids = [aws_security_group.apache_prod_web.id]
}

resource "aws_autoscaling_group" "apache_prod_web" {
  name                = "apache-prod-web"
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, aws_default_subnet.default_az3.id]
  desired_capacity    = var.apache_web_server_desired_capacity
  max_size            = var.apache_web_server_max_size
  min_size            = var.apache_web_server_min_size

  launch_template {
    id      = aws_launch_template.apache_prod_web.id
    version = "$Latest"
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "apache_prod_web" {
  autoscaling_group_name = aws_autoscaling_group.apache_prod_web.id
  elb                    = aws_elb.apache_prod_web.id
}

