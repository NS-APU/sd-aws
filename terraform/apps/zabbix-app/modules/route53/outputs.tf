output "zone_name-prod" {
  value = aws_route53_zone.zabbix-app-prod.name
}

output "zone_id-prod" {
  value = aws_route53_zone.zabbix-app-prod.id
}
