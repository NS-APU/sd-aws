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
  default_tags {
    tags = {
      project = "BabaCafe"
      env = "staging"
    }
  }
}

#
# Network
#
data "aws_vpc" "babacafe" {
  cidr_block = local.vpc_cidr_block
}

module "subnet" {
  source = "../modules/networks/private_subnet"
  vpc_id = data.aws_vpc.babacafe.id
  cidr_block = local.subnet_cidr_block
}

data "aws_route53_zone" "babacafe-stag" {
  name = "stag.babacafe.${local.domain_name}"
}

module "s3" {
  source = "../modules/s3"
  s3_bucket_name = data.aws_route53_zone.babacafe-stag.name
}

module "rds" {
  source = "../modules/rds"
  allocated_storage = 10
  tag_name = "babacafe-staging"
  subnet_ids = [module.subnet.subnet_id]
  vpc_id = data.aws_vpc.babacafe.id
  vpc_cidr_block = local.vpc_cidr_block
}

module "ecs" {
  source = "../modules/ecs"
  name_prefix = "babacafe-staging"
  task_definition_path = "${path.module}/task_definition.json"
  subnet_ids = [module.subnet.subnet_id]
  vpc_id = data.aws_vpc.babacafe.id
  vpc_cidr_block = local.vpc_cidr_block
}