resource "aws_cloudwatch_log_group" "babacafe" {
  name              = "/ecs/${var.log_group_name}"
  retention_in_days = 30
}
