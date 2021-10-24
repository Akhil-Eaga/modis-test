provider "aws" {
  profile = "default"
  region  = "ap-southeast-2"
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
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["130.95.254.133/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" = "true"
  }
}

# resource "aws_instance" "apache_prod_web" {
#   # Ubuntu Server AMI
#   ami           = "ami-0567f647e75c7bc05"
#   instance_type = "t2.micro"

#   user_data = <<-EOF
#   #!/bin/sh
#   sudo apt-get update
#   sudo apt install -y apache2
#   sudo systemctl status apache2
#   sudo systemctl start apache2
#   sudo chown -R $USER:$USER /var/www/html
#   sudo echo "<html><body><h1>Hello from Apache web server</h1></body></html>" > /var/www/html/index.html
#   EOF

#   security_groups = [aws_security_group.apache_prod_web.name]

#   tags = {
#     "Name" = "apache_web_server"
#   }
# }

resource "aws_elb" "apache_prod_web" {
  name = "apache-prod-web"
  #   instances       = aws_instance.prod_web.*.id
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
  image_id               = "ami-0567f647e75c7bc05"
  instance_type          = "t2.micro"
  user_data              = filebase64("install_apache.sh")
  vpc_security_group_ids = [aws_security_group.apache_prod_web.id]
}

resource "aws_autoscaling_group" "apache_prod_web" {
  name                = "apache-prod-web"
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, aws_default_subnet.default_az3.id]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2

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

