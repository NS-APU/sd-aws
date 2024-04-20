resource "aws_db_instance" "babacafe" {
  allocated_storage = var.allocated_storage
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "15.2"
  instance_class    = "db.t3.small"
  db_subnet_group_name = aws_db_subnet_group.babacafe.name
  vpc_security_group_ids = [aws_security_group.sg_allow_psql.id]
  multi_az = false
  username = "test"
  password = "babatest"
  tags = {
    name = var.tag_name
  }
}

resource "aws_db_subnet_group" "babacafe" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids
}

#
# postgresql security group
#
resource "aws_security_group" "sg_allow_psql" {
  name = "sg_allow_psql"  
  description = "allow postgresql port"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "sg_allow_psql" {
  security_group_id = aws_security_group.sg_allow_psql.id
  cidr_ipv4 = var.vpc_cidr_block
  from_port         = 5432
  to_port           = 5432
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "sg_allow_psql" {
  security_group_id = aws_security_group.sg_allow_psql.id
  cidr_ipv4 = var.vpc_cidr_block
  ip_protocol = -1
}
