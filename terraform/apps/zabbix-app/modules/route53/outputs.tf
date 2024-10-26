output "zone_name_prod_zabbix" {
  value = aws_route53_zone.zabbix-prod.name
}

output "zone_id_prod_zabbix" {
  value = aws_route53_zone.zabbix-prod.id
}

output "zone_name_prod_grafana" {
  value = aws_route53_zone.grafana-prod.name
}

output "zone_id_prod_grafana" {
  value = aws_route53_zone.grafana-prod.id
}