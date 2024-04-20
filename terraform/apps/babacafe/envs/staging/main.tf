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
  source = "../../modules/networks/vpc"
  vpc_cidr_block = "10.0.3.0/24"
}

module "s3" {
  source = "../../modules/s3"
  s3_bucket_name = "babacafe-staging"
}

module "private_subnet" {
  source = "../../modules/networks/private_subnet"
  vpc_id = module.vpc.vpc_id
  cidr_block = module.vpc.vpc_cidr_block
}

module "rds" {
  source = "../../modules/rds"
  allocated_storage = 10
  tag_name = "babacafe-staging"
  vpc_id = module.vpc.vpc_id
  subnet_ids = [module.private_subnet.subnet_id]
  vpc_cidr_block = module.vpc.vpc_cidr_block
}

module "iam" {
  source = "../../modules/iam"
  app-name = "babacafe-staging"
}

data "aws_ecr_repository" "babacafe" {
  name = "babacafe-ecr-repo"
}

module "ecs" {
  source = "../../modules/ecs"
  name_prefix = "babacafe-staging"
  task_execution_role_arn = module.iam.task_execution_role
  task_role_arn = module.iam.task_execution_role
  cpu = "256"
  memory = "512"
  name = "babacafe-staging"
  image = "${data.aws_ecr_repository.babacafe.repository_url}:latest"
  subnet_ids = [module.private_subnet.subnet_id]
  vpc_id = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
}
