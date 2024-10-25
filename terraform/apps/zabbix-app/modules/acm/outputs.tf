output "certificate_arn-prod" {
  value = aws_acm_certificate.zabbix-app.arn
}

output "certificate_arn-stag" {
  value = aws_acm_certificate.zabbix-app-stag.arn
}
