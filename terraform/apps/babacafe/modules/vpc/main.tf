resource "aws_vpc" "babacafe-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.babacafe-vpc.id
  cidr_block        = var.subnet_cidr
}

resource "aws_vpc_security_group_egress_rule" "outbound_allow_all" {
  security_group_id = aws_vpc.babacafe-vpc.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_port" {
  security_group_id = aws_vpc.babacafe-vpc.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_rds_port" {
  security_group_id = aws_vpc.babacafe-vpc.id
  cidr_ipv4 = "10.0.0.0/16"
  from_port         = 5432
  to_port           = 5432
  ip_protocol = "tcp"
}