output "zone_name-prod" {
  value = aws_route53_zone.zabbix-app-prod.name
}

output "zone_name-stag" {
  value = aws_route53_zone.zabbix-app-stag.name
}

output "zone_id-prod" {
  value = aws_route53_zone.zabbix-app-prod.id
}

output "zone_id-stag" {
  value = aws_route53_zone.zabbix-app-stag.id
}
