resource "aws_internet_gateway" "zabbix-app" {
  vpc_id = var.vpc_id
}