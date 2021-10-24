output "load-balancer-public-ip" {
  value = aws_elb.apache_prod_web.dns_name
}

