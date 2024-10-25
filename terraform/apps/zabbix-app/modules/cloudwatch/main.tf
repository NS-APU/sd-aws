resource "aws_cloudwatch_log_group" "zabbix-app" {
  name              = "/ecs/${var.log_group_name}"
  retention_in_days = 30
}
