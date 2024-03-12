variable "name_prefix" {
  type = string
}

variable "task_definition_path" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "cpu" {
  type = string
  default = "1024"
}

variable "memory" {
  type = string
  default = "1024"
}