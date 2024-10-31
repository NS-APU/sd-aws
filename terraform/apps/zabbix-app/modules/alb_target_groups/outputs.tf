output "arn" {
  value = aws_lb_target_group.zabbix-app.arn
}

output "grafana_arn" {
  value = aws_lb_target_group.grafana-app.arn
}
