variable "allocated_storage" {
  type    = number
  default = 10
}

variable "tag_name" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "db_name" {
  type    = string
  default = "babacafe"
}
