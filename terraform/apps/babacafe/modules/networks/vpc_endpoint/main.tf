resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.ecr.api"
  subnet_ids = var.subnet_ids
  security_group_ids = var.security_group_ids
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.subnet_ids
  security_group_ids = var.security_group_ids
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  subnet_ids = var.subnet_ids
}