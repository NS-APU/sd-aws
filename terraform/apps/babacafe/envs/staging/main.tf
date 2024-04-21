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

data "aws_vpc" "babacafe" {
  cidr_block = "10.0.0.0/16"
}

module "s3" {
  source = "../../modules/s3"
  s3_bucket_name = "babacafe-staging"
}

module "private_subnet" {
  source = "../../modules/networks/private_subnet"
  vpc_id = data.aws_vpc.babacafe.id
  cidr_block_1a = "10.0.129.0/24"
  cidr_block_1c = "10.0.130.0/24"
  availability_zone_1a = "ap-northeast-1a"
  availability_zone_1c = "ap-northeast-1c"
} 

data "aws_lb" "selected" {
  name = "babacafe-alb"
}

data "aws_lb_listener" "selected443" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = 443
}

module "alb_target_group" {
  source = "../../modules/alb_target_groups"
  zone_name = "stag.babacafe.systemdesign-apu.com"
  path_pattern = "/api/*"
  vpc_id = data.aws_vpc.babacafe.id
  port = 3000
  alb_tg_name = "babacafe-staging"
  listener_arn = data.aws_lb_listener.selected443.arn 
}

module "rds" {
  source = "../../modules/rds"
  allocated_storage = 10
  tag_name = "babacafe-staging"
  vpc_id = data.aws_vpc.babacafe.id
  subnet_ids = module.private_subnet.subnet_ids
  vpc_cidr_block = data.aws_vpc.babacafe.cidr_block
}

module "iam" {
  source = "../../modules/iam"
  app-name = "babacafe-staging"
}

data "aws_ecr_repository" "babacafe" {
  name = "babacafe-ecr-repo"
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"
  log_group_name = "babacafe-staging"
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
  log_group_name = module.cloudwatch.log_group_name
  subnet_ids = module.private_subnet.subnet_ids
  vpc_id = data.aws_vpc.babacafe.id
  vpc_cidr_block = data.aws_vpc.babacafe.cidr_block
  target_group_arn = module.alb_target_group.arn
  env = [
    {"name": "DBHOST", "value": module.rds.address},
    {"name": "POSTGRES_USER", "value": "babacafe"},
    {"name": "POSTGRES_PASSWORD", "value": "babacafe"},
    {"name": "POSTGRES_DB", "value": "babacafe"},
    {"name": "TZ", "value": "Asia/Tokyo"},
    {"name": "JWT_SECRET_KEY", "value": "secret"},
  ]
}
