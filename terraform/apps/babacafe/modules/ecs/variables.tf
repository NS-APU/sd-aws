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

variable "container_name" {
  description = "The name of a container"
  type        = string
}

variable "container_image" {
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

variable "target_group_arn" {
  type = string
}

variable "env" {
  description = "environment for this container_definition"
  type        = list(map(string))
}
