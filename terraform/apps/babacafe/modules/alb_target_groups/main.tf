#
# ALB target group
#
resource "aws_lb_target_group" "babacafe" {
  name = "${var.alb_tg_name}"
  port = var.port
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.vpc_id

  slow_start = 300

  health_check {
    interval = 60
    path = "/"
    port = 3000
    timeout = 10
    unhealthy_threshold = 5
    matcher = 200
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "babacafe" {
  listener_arn = var.listener_arn
  priority = var.listener_rule_priority
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


