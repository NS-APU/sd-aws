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
    key    = "babacafe-production.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      project = "BabaCafe"
      env     = "production"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

data "aws_vpc" "babacafe" {
  cidr_block = "10.0.0.0/16"
}

data "aws_acm_certificate" "prod" {
  provider = aws.virginia
  domain   = "babacafe.systemdesign-apu.com"
}

module "cloudfront" {
  source              = "../../modules/cloudfront"
  zone_name           = "babacafe.systemdesign-apu.com"
  s3_domain_name      = module.s3.bucket_domain_name
  s3_origin_id        = module.s3.id
  acm_certificate_arn = data.aws_acm_certificate.prod.arn
}

module "s3" {
  source         = "../../modules/s3"
  s3_bucket_name = "babacafe-production"
  cloudfront_arn = module.cloudfront.arn
}

data "aws_route53_zone" "babacafe" {
  name = "babacafe.systemdesign-apu.com"
}

resource "aws_route53_record" "babacafe" {
  zone_id = data.aws_route53_zone.babacafe.zone_id
  name    = data.aws_route53_zone.babacafe.name
  type    = "A"

  alias {
    name                   = module.cloudfront.domain_name
    zone_id                = module.cloudfront.zone_id
    evaluate_target_health = false
  }
}


module "private_subnet" {
  source               = "../../modules/networks/private_subnet"
  name_prefix          = "babacafe-production"
  vpc_id               = data.aws_vpc.babacafe.id
  cidr_block_1a        = "10.0.131.0/24"
  cidr_block_1c        = "10.0.132.0/24"
  availability_zone_1a = "ap-northeast-1a"
  availability_zone_1c = "ap-northeast-1c"
}

// gateway vpc endpoint
data "aws_vpc_endpoint" "s3" {
  vpc_id       = data.aws_vpc.babacafe.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "s3-1a" {
  vpc_endpoint_id = data.aws_vpc_endpoint.s3.id
  route_table_id  = module.private_subnet.route_table_1a_id
}

resource "aws_vpc_endpoint_route_table_association" "s3-1c" {
  vpc_endpoint_id = data.aws_vpc_endpoint.s3.id
  route_table_id  = module.private_subnet.route_table_1c_id
}

data "aws_lb" "selected" {
  name = "babacafe-alb"
}

data "aws_lb_listener" "selected443" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = 443
}

module "alb_target_group" {
  source                 = "../../modules/alb_target_groups"
  zone_name              = "api.babacafe.systemdesign-apu.com"
  path_pattern           = "/*"
  vpc_id                 = data.aws_vpc.babacafe.id
  port                   = 3000
  alb_tg_name            = "babacafe-production"
  listener_arn           = data.aws_lb_listener.selected443.arn
  listener_rule_priority = 2
}

module "rds" {
  source            = "../../modules/rds"
  allocated_storage = 10
  tag_name          = "babacafe-production"
  name_prefix       = "babacafe-production"
  vpc_id            = data.aws_vpc.babacafe.id
  subnet_ids        = module.private_subnet.subnet_ids
  vpc_cidr_block    = data.aws_vpc.babacafe.cidr_block
}

module "iam" {
  source      = "../../modules/iam"
  name_prefix = "babacafe-production"
}

data "aws_ecr_repository" "babacafe" {
  name = "babacafe-ecr-repo"
}

module "cloudwatch" {
  source         = "../../modules/cloudwatch"
  log_group_name = "babacafe-production"
}

module "ecs" {
  source      = "../../modules/ecs"
  name_prefix = "babacafe-production"

  container_cpu    = "256"
  container_memory = "512"
  container_name   = "babacafe-production"
  container_image  = "${data.aws_ecr_repository.babacafe.repository_url}:latest"

  task_execution_role_arn = module.iam.task_execution_role
  task_role_arn           = module.iam.task_execution_role
  log_group_name          = module.cloudwatch.log_group_name
  subnet_ids              = module.private_subnet.subnet_ids
  vpc_id                  = data.aws_vpc.babacafe.id
  vpc_cidr_block          = data.aws_vpc.babacafe.cidr_block
  target_group_arn        = module.alb_target_group.arn
  env = [
    { "name" : "DBHOST", "value" : module.rds.address },
    { "name" : "POSTGRES_USER", "value" : "babacafe" },
    { "name" : "POSTGRES_PASSWORD", "value" : "babacafe" },
    { "name" : "POSTGRES_DB", "value" : "babacafe" },
    { "name" : "TZ", "value" : "Asia/Tokyo" },
    { "name" : "JWT_SECRET_KEY", "value" : "secret" },
  ]
}
