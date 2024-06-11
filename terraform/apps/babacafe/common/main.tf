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
    key    = "babacafe-common.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      project = "BabaCafe"
      env     = "common"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
  default_tags {
    tags = {
      project = "BabaCafe"
      env     = "common"
    }
  }
}

#
# Networks
#
module "vpc" {
  source         = "../modules/networks/vpc"
  vpc_cidr_block = local.vpc_cidr_block
}

module "private_subnet" {
  source               = "../modules/networks/private_subnet"
  name_prefix          = "vpc-endpoint"
  vpc_id               = module.vpc.vpc_id
  cidr_block_1a        = "10.0.64.0/24"
  cidr_block_1c        = "10.0.65.0/24"
  availability_zone_1a = "ap-northeast-1a"
  availability_zone_1c = "ap-northeast-1c"
}

module "vpc_endpoint" {
  source     = "../modules/networks/vpc_endpoint"
  aws_region = "ap-northeast-1"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.private_subnet.subnet_ids
}

module "igw" {
  source = "../modules/networks/internet_gateway"
  vpc_id = module.vpc.vpc_id
}

module "alb_subnet" {
  source               = "../modules/networks/public_subnet"
  cidr_block_1a        = local.alb_subnet_cidr_block_1a
  cidr_block_1c        = local.alb_subnet_cidr_block_1c
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.igw.igw_id
  availability_zone_1a = local.availability_zone_1a
  availability_zone_1c = local.availability_zone_1c
}

#
# ACM
#
module "acm" {
  source         = "../modules/acm"
  zone_name-prod = module.route53.zone_name-prod
  zone_name-stag = module.route53.zone_name-stag
  zone_id-prod   = module.route53.zone_id-prod
  zone_id-stag   = module.route53.zone_id-stag
}

module "acm_virginia" {
  source = "../modules/acm"
  providers = {
    aws = aws.virginia
  }
  zone_name-prod = module.route53.zone_name-prod
  zone_name-stag = module.route53.zone_name-stag
  zone_id-prod   = module.route53.zone_id-prod
  zone_id-stag   = module.route53.zone_id-stag
}

#
# ALB
#
module "alb" {
  source               = "../modules/alb"
  name_prefix          = local.name_prefix
  alb_subnet_ids       = module.alb_subnet.subnet_ids
  vpc_id               = module.vpc.vpc_id
  certificate_arn_prod = module.acm.certificate_arn-prod
  certificate_arn_stag = module.acm.certificate_arn-stag
}

#
# ECR
#
module "ecr" {
  source      = "../modules/ecr"
  name_prefix = local.name_prefix
}

#
# Route53
#
module "route53" {
  source       = "../modules/route53"
  domain_name  = local.domain_name
  alb_dns_name = module.alb.dns_name
  alb_zone_id  = module.alb.zone_id
}
