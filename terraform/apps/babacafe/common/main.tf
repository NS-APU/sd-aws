terraform {
  required_version = ">= 1.6.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31.0"
    }
  }

  backend "s3" {
    bucket = "sd-apu-terraform-state"
    key = "babacafe-common.tfstate"
    region = "ap-northeast-1"
  }
}

#
# Staging VPC Subnets
#
data "staging" "staging" {
}

#
# Production VPC Subnets
#
module "vpc" {
  source = "../modules/vpc"
  subnet_cidr = "10.0.1.0/24"
}

#
# ALB
#
module "alb" {
  source = "../modules/alb"
  alb_name = "babacafe"
  alb_security_groups = [ module.vpc.sg_ingress_allow_https_port_id ]
  alb_subnet_ids = [ module.vpc.subnet_id ]
}