#
# ALB
#
resource "aws_lb" "alb" {
  load_balancer_type = "application"
  name               = "${var.name_prefix}-alb"

  security_groups = [aws_security_group.sg_alb.id]
  subnets         = var.alb_subnet_ids
}

#
# security group
#
resource "aws_security_group" "sg_alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "allow http/https port"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "sg_alb-http" {
  security_group_id = aws_security_group.sg_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "sg_alb-https" {
  security_group_id = aws_security_group.sg_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "sg_alb" {
  security_group_id = aws_security_group.sg_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

#
# ALB listener rules
#
resource "aws_lb_listener" "babacafe-https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn_prod

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "503 Service Temporarily Unavailable"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener_certificate" "staging" {
  listener_arn    = aws_lb_listener.babacafe-https.arn
  certificate_arn = var.certificate_arn_stag
}

resource "aws_lb_listener" "babacafe-http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
