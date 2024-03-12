variable "allocated_storage" {
  type = number
  default = 10
}

variable "tag_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}