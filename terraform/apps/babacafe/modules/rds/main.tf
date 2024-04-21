resource "aws_db_instance" "babacafe" {
  allocated_storage = var.allocated_storage
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "15.5"
  instance_class    = "db.t3.small"
  db_subnet_group_name = aws_db_subnet_group.babacafe.name
  vpc_security_group_ids = [aws_security_group.sg_allow_psql.id]
  multi_az = false
  db_name = var.db_name
  skip_final_snapshot = true
  username = "babacafe"
  password = "babacafe"
  parameter_group_name = "babacafe-db-parameter-group"
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
  cidr_ipv4 = "0.0.0.0/0"
  from_port         = 5432
  to_port           = 5432
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "sg_allow_psql" {
  security_group_id = aws_security_group.sg_allow_psql.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_db_parameter_group" "babacafe" {
  name   = "babacafe-db-parameter-group"
  family = "postgres15"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}
