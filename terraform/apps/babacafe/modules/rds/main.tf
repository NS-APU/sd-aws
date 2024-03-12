resource "aws_db_instance" "babacafe" {
  allocated_storage = var.allocated_storage
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "15.2"
  instance_class    = "db.t3.small"
  vpc_security_group_ids = var.security_group_ids
  tags = {
    name = var.tag_name
  }
}

resource "aws_db_subnet_group" "babacafe" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids
}