resource "aws_ecr_repository" "zabbix-app" {
  name = "${var.name_prefix}-ecr-repo"
}
