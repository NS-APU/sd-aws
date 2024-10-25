output "vpc_id" {
  value = aws_vpc.zabbix-app-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.zabbix-app-vpc.cidr_block
}
