#
# https security group
#
resource "aws_security_group" "sg_allow_https" {
  name = "sg_allow_https"
  description = ""
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_port" {
  security_group_id = aws_security_group.sg_allow_https.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.sg_allow_https.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}

#
# postgresql security group
#
resource "aws_security_group" "sg_allow_psql" {
  name = "sg_allow_psql"  
  description = ""
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_psql_port" {
  security_group_id = aws_security_group.sg_allow_psql.id
  cidr_ipv4 = var.vpc_cidr_block
  from_port         = 5432
  to_port           = 5432
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.sg_allow_psql.id
  cidr_ipv4 = var.vpc_cidr_block
  ip_protocol = -1
}