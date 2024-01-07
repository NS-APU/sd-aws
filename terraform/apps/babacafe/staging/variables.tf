variable "aws_region" {
  type = string
  default = "ap-northeast-1"
}

variable "terraform_state_bucket" {
  type = string
  default = "sd-apu-terraform-state"
}

variable "terraform_state_bucket_region" {
  type = string
  default = "ap-northeast-1"
}