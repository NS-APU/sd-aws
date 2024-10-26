output "certificate_arn_prod_zabbix" {
  value = aws_acm_certificate.zabbix-app-prod-zabbix.arn
}

output "certificate_arn_prod_grafana" {
  value = aws_acm_certificate.zabbix-app-prod-grafana.arn
}

//output "certificate_arn-stag" {
//  value = aws_acm_certificate.zabbix-app-stag.arn
//}
