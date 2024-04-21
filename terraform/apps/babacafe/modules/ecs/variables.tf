variable "name_prefix" {
  type = string
}

variable "task_execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "cpu" {
  type = string
  default = "1024"
}

variable "memory" {
  type = string
  default = "1024"
}

variable "name" {
  type = string
}

variable "image" {
  type = string
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

variable "target_group_arn" {
  type = string
}

variable "env" {
  type = list(map(string))
}
