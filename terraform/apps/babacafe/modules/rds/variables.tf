variable "rds_allocated_storage" {
  type = number
  default = 10
}

variable "rds_tag_name" {
  type = string
}

variable "rds_subnet_ids" {
  type = list(string)
}