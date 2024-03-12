variable "alb_name" {
  type = string
  default = "babacafe-alb"
}

variable "alb_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}