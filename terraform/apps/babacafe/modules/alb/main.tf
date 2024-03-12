resource "aws_lb" "alb" {
  load_balancer_type = "application"
  name               = var.alb_name

  security_groups = [aws_security_group.sg_allow_https.id]
  subnets = var.alb_subnet_ids
}

#
# https security group
#
resource "aws_security_group" "sg_allow_https" {
  name = "sg_allow_https"
  description = "allow https port"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "sg_allow_https" {
  security_group_id = aws_security_group.sg_allow_https.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "sg_allow_https" {
  security_group_id = aws_security_group.sg_allow_https.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}