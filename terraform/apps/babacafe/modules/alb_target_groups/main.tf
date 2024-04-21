#
# ALB target group
#
resource "aws_lb_target_group" "babacafe" {
  name = "${var.alb_tg_name}"
  port = var.port
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.vpc_id
}

resource "aws_lb_listener_rule" "babacafe" {
  listener_arn = var.listener_arn
  priority = 1
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.babacafe.arn
  }
  condition {
    host_header {
      values = [var.zone_name]
    }
  }
  condition {
    path_pattern {
      values = [var.path_pattern]
    }
  }
}
