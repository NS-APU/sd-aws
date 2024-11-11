variable "ecr_repository_list" {
  type = list(string)
  default = ["zabbix-server", "zabbix-frontend", "grafana"]
}
