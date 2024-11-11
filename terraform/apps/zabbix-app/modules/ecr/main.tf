resource "aws_ecr_repository" "zabbix-server" {
  name = "zabbix-server-ecr-repo"
}

resource "aws_ecr_repository" "zabbix-frontend" {
  name = "zabbix-frontend-ecr-repo"
}

resource "aws_ecr_repository" "grafana" {
  name = "grafana-ecr-repo"
}
