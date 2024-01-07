resource "aws_db_instance" "rds" {
  allocated_storage = var.rds_allocated_storage
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "15.2"
  instance_class    = "db.t3.small"
  tags = {
    name = var.rds_tag_name
  }
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "rds-subnet-group"
  subnet_ids = var.rds_subnet_ids
}