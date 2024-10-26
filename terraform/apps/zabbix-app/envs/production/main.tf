terraform {
  required_version = ">= 1.6.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      project = "Zabbix-App"
      env     = "production"
    }
  }
}

data "aws_vpc" "zabbix-app" {
  cidr_block = "10.3.0.0/16"
}

data "aws_route53_zone" "zabbix-app" {
  name = "zabbix.systemdesign-apu.com"
}

data "aws_route53_zone" "grafana-app" {
  name = "grafana.systemdesign-apu.com"
}

data "aws_lb" "selected" {
  name = "zabbix-app-alb"
}

resource "aws_route53_record" "zabbix-app" {
  zone_id = data.aws_route53_zone.zabbix-app.zone_id
  name    = data.aws_route53_zone.zabbix-app.name
  type    = "A"

  alias {
    name                   = data.aws_route53_zone.zabbix-app.name
    zone_id                = data.aws_lb.selected.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "grafana-app" {
  zone_id = data.aws_route53_zone.grafana-app.zone_id
  name    = data.aws_route53_zone.grafana-app.name
  type    = "A"

  alias {
    name                   = data.aws_route53_zone.grafana-app.name
    zone_id                = data.aws_lb.selected.zone_id
    evaluate_target_health = false
  }
}

module "private_subnet" {
  source               = "../../modules/networks/private_subnet"
  name_prefix          = "zabbix-app-production"
  vpc_id               = data.aws_vpc.zabbix-app.id
  cidr_block_1a        = "10.3.131.0/24"
  cidr_block_1c        = "10.3.132.0/24"
  availability_zone_1a = "ap-northeast-1a"
  availability_zone_1c = "ap-northeast-1c"
}

data "aws_lb_listener" "selected443" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = 443
}

module "alb_target_group" {
  source                 = "../../modules/alb_target_groups"
  vpc_id                 = data.aws_vpc.zabbix-app.id
  listener_arn           = data.aws_lb_listener.selected443.arn
  listener_rule_priority = 2
  alb_grafana_tg_name    = "zabbix-app-production"
  grafana_port           = 3000
  grafana_zone_name      = "grafana.systemdesign-apu.com"
  alb_zabbix_tg_name     = "zabbix-app-production"
  zabbix_port            = 8080
  zabbix_zone_name       = "zabbix.systemdesign-apu.com"
}

module "rds" {
  source            = "../../modules/rds"
  allocated_storage = 10
  tag_name          = "zabbix-app-production"
  name_prefix       = "zabbix-app-production"
  vpc_id            = data.aws_vpc.zabbix-app.id
  subnet_ids        = module.private_subnet.subnet_ids
}

module "iam" {
  source      = "../../modules/iam"
  name_prefix = "zabbix-app-production"
}

data "aws_ecr_repository" "zabbix-app" {
  name = "zabbix-app-ecr-repo"
}

module "cloudwatch" {
  source         = "../../modules/cloudwatch"
  log_group_name = "zabbix-app-production"
}

