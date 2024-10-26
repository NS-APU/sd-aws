#
# ALB target group
#

# Grafana
resource "aws_lb_target_group" "grafana-app" {
  name        = var.alb_grafana_tg_name
  port        = var.grafana_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  slow_start = 300

  health_check {
    interval            = 60
    path                = "/"
    port                = 3000
    timeout             = 10
    unhealthy_threshold = 5
    matcher             = 200
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "grafana-app" {
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana-app.arn
  }
  condition {
    host_header {
      values = [var.grafana_zone_name]
    }
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

# Zabbix-frontend
resource "aws_lb_target_group" "zabbix-app" {
  name        = var.alb_zabbix_tg_name
  port        = var.zabbix_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  slow_start = 300

  health_check {
    interval            = 60
    path                = "/"
    port                = 8080
    timeout             = 10
    unhealthy_threshold = 5
    matcher             = 200
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "zabbix-app" {
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.zabbix-app.arn
  }
  condition {
    host_header {
      values = [var.zabbix_zone_name]
    }
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

