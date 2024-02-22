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
    key = "babacafe-staging.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "vpc" {
  source = "../modules/vpc"
  subnet_cidr = "10.0.3.0/24"
}

module "s3" {
  source = "../modules/s3"
  s3_bucket_name = "babacafe-staging"
}

module "rds" {
  source = "../modules/rds"
  rds_allocated_storage = 10
  rds_tag_name = "babacafe-staging"
  rds_subnet_ids = [module.vpc.subnet_id]
}