variable "name_prefix" {
  type = string
}

variable "alb_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "certificate_arn_prod_zabbix" {
  type = string
}

variable "certificate_arn_prod_grafana" {
  type = string
}
