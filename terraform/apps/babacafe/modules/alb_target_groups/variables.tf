variable "alb_tg_name" {
  type = string
}

variable "port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "path_pattern" {
  type = string
}

variable "listener_arn" {
  type = string
}

variable "listener_rule_priority" {
  type = string
}
