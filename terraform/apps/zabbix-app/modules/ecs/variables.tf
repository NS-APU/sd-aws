variable "name_prefix" {
  type = string
}

variable "task_execution_role_arn" {
  description = ""
  type        = string
}

variable "task_role_arn" {
  type = string
}

variable "container_cpu" {
  description = "The number of cpu units reserved for the container"
  type        = string
}

variable "container_memory" {
  description = "The amount (in MiB) of memory to present to the container"
  type        = string
}

variable "container_name_1" {
  description = "The name of a container no.1"
  type        = string
}

variable "container_name_2" {
  description = "The name of a container no.2"
  type        = string
}

variable "container_name_3" {
  description = "The name of a container no.3"
  type        = string
}

variable "container_image_1" {
  description = "The image used to start a container"
  type        = string
}

variable "container_image_2" {
  description = "The image used to start a container"
  type        = string
}

variable "container_image_3" {
  description = "The image used to start a container"
  type        = string
}

variable "log_group_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "target_group_arn_grafana" {
  type = string
}

variable "target_group_arn_zabbix" {
  type = string
}

variable "env_zabbix_server" {
  description = "Environment variables for Zabbix Server"
  type        = list(map(string))
}

variable "env_zabbix_frontend" {
  description = "Environment variables for Zabbix Frontend"
  type        = list(map(string))
}

variable "env_grafana" {
  description = "Environment variables for Grafana"
  type        = list(map(string))
}
