variable "alb_name" {
  type = string
  default = "babacafe-alb"
}

variable "alb_security_groups" {
  type = list(string)
}

variable "alb_subnet_ids" {
  type = list(string)
}