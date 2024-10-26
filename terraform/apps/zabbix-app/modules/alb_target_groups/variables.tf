variable "alb_grafana_tg_name" {
  type = string
}

variable "alb_zabbix_tg_name" {
  type = string
}

variable "grafana_port" {
  type = number
}

variable "zabbix_port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "grafana_zone_name" {
  type = string
}

variable "zabbix_zone_name" {
  type = string
}

variable "listener_arn" {
  type = string
}

variable "grafana_listener_rule_priority" {
  type = string
}

variable "zabbix_listener_rule_priority" {
  type = string
}