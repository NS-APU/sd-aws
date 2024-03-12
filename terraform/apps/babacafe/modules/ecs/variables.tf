variable "name_prefix" {
  type = string
}

variable "task_definition_path" {
  type = string
}

variable "subnet_ids" {
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

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}