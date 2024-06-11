resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.sg_vpc_endpoint.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.sg_vpc_endpoint.id]
  private_dns_enabled = true

}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.sg_vpc_endpoint.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
}

#
# security group
#
resource "aws_security_group" "sg_vpc_endpoint" {
  name        = "babacafe-vpc-endpoint-sg"
  description = "allow http/https port"
  vpc_id      = var.vpc_id
}

data "aws_vpc" "babacafe" {
  id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "sg_vpc_endpoint-https" {
  security_group_id = aws_security_group.sg_vpc_endpoint.id
  cidr_ipv4         = data.aws_vpc.babacafe.cidr_block
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "sg_vpc_endpoint-https" {
  security_group_id = aws_security_group.sg_vpc_endpoint.id
  cidr_ipv4         = data.aws_vpc.babacafe.cidr_block
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}