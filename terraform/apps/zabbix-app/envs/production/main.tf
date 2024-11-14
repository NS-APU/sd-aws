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
    key    = "zabbix-production.tfstate"
    region = "ap-northeast-1"
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

module "private_subnet" {
  source               = "../../modules/networks/private_subnet"
  name_prefix          = "zabbix-app-production"
  vpc_id               = data.aws_vpc.zabbix-app.id
  cidr_block_1a        = "10.3.131.0/24"
  cidr_block_1c        = "10.3.132.0/24"
  availability_zone_1a = "ap-northeast-1a"
  availability_zone_1c = "ap-northeast-1c"
}

// gateway vpc endpoint
data "aws_vpc_endpoint" "s3" {
  vpc_id       = data.aws_vpc.zabbix-app.id
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

data "aws_lb_listener" "selected443" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = 443
}

// NAT Gateway
data "aws_nat_gateway" "nat-gw" {
  vpc_id = data.aws_vpc.zabbix-app.id
}

resource "aws_route" "nat-gw-1a" {
  route_table_id = module.private_subnet.route_table_1a_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = data.aws_nat_gateway.nat-gw.id
}

resource "aws_route" "nat-gw-1c" {
  route_table_id = module.private_subnet.route_table_1c_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = data.aws_nat_gateway.nat-gw.id
}

module "alb_target_group" {
  source                 = "../../modules/alb_target_groups"
  vpc_id                 = data.aws_vpc.zabbix-app.id
  listener_arn           = data.aws_lb_listener.selected443.arn
  grafana_listener_rule_priority = 1
  zabbix_listener_rule_priority = 2
  alb_grafana_tg_name    = "grafana-app-production"
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

data "aws_ecr_repository" "zabbix-server" {
  name = "zabbix-server-ecr-repo"
}

data "aws_ecr_repository" "zabbix-frontend" {
  name = "zabbix-server-ecr-repo"
}

data "aws_ecr_repository" "grafana" {
  name = "zabbix-server-ecr-repo"
}

module "cloudwatch" {
  source         = "../../modules/cloudwatch"
  log_group_name = "zabbix-app-production"
}

module "ecs" {
  source = "../../modules/ecs"
  name_prefix = "zabbix-app-production"

  container_cpu = "256"
  container_memory = "512"
  container_name_1 = "zabbix-server"
  container_name_2 = "zabbix-frontend"
  container_name_3 = "grafana"
  container_image_1 = "${data.aws_ecr_repository.zabbix-server.repository_url}:latest"
  container_image_2 = "${data.aws_ecr_repository.zabbix-frontend.repository_url}:latest" 
  container_image_3 = "${data.aws_ecr_repository.grafana.repository_url}:latest" 
  task_execution_role_arn = module.iam.task_execution_role 
  task_role_arn = module.iam.task_execution_role 
  log_group_name = module.cloudwatch.log_group_name
  subnet_ids = module.private_subnet.subnet_ids
  vpc_id = data.aws_vpc.zabbix-app.id
  vpc_cidr_block = data.aws_vpc.zabbix-app.cidr_block
  target_group_arn_grafana = module.alb_target_group.grafana_arn
  target_group_arn_zabbix = module.alb_target_group.arn


  env_zabbix_server = [
    { name = "POSTGRES_USER", value = "zabbix" },
    { name = "POSTGRES_PASSWORD", value = "zabbix-app" },
    { name = "POSTGRES_DB", value = "zabbix" },
    { name = "DB_SERVER_HOST", value = module.rds.address },
    { name = "DB_SERVER_PORT", value = "5432" }
  ]
   env_zabbix_frontend = [
    { name = "POSTGRES_USER", value = "zabbix" },
    { name = "DB_SERVER_HOST", value =  module.rds.address },
    { name = "ZBX_SERVER_HOST", value = "localhost:10051" },
    { name = "POSTGRES_PASSWORD", value = "zabbix-app" },
    { name = "POSTGRES_DB", value = "zabbix" },
    { name = "ZBX_SERVER_PORT", value = "10051" },
    { name = "PHP_TZ", value = "Asia/Tokyo" }
  ]

    env_grafana = [
    { name = "GF_SECURIT_ADMIN_USER", value = "admin" },
    { name = "GF_SECURITY_ADMIN_PASSWORD", value = "12345" },
    { name = "TZ", value = "Asia/Tokyo" }
  ]
}
