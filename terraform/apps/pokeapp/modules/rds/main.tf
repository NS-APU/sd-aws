resource "aws_db_instance" "pokeapp" {
  allocated_storage      = var.allocated_storage
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.small"
  db_subnet_group_name   = aws_db_subnet_group.pokeapp.name
  vpc_security_group_ids = [aws_security_group.sg_allow_psql.id]
  multi_az               = false
  db_name                = var.db_name
  skip_final_snapshot    = true
  username               = "pokeapp"
  password               = "pokeapp"
  parameter_group_name   = "${var.name_prefix}-db-parameter-group"
  tags = {
    name = var.tag_name
  }
}

resource "aws_db_subnet_group" "pokeapp" {
  name       = "${var.name_prefix}-rds-subnet-group"
  subnet_ids = var.subnet_ids
}

#
# postgresql security group
#
resource "aws_security_group" "sg_allow_psql" {
  name        = "${var.name_prefix}-sg-allow-psql"
  description = "allow postgresql port"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "sg_allow_psql" {
  security_group_id = aws_security_group.sg_allow_psql.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "sg_allow_psql" {
  security_group_id = aws_security_group.sg_allow_psql.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_db_parameter_group" "pokeapp" {
  name   = "${var.name_prefix}-db-parameter-group"
  family = "postgres15"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}
