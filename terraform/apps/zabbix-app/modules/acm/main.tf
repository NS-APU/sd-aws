//
// Zabbix DNS Record
//
resource "aws_acm_certificate" "zabbix-app-prod-zabbix" {
  domain_name               = var.zone_name-prod-zabbix
  subject_alternative_names = ["*.${var.zone_name-prod-zabbix}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dns_verify-prod-zabbix" {
  for_each = {
    for dvo in aws_acm_certificate.zabbix-app-prod-zabbix.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id-prod-zabbix
}

resource "aws_acm_certificate_validation" "zabbix-app-prod-zabbix" {
  certificate_arn         = aws_acm_certificate.zabbix-app-prod-zabbix.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_verify-prod-zabbix : record.fqdn]
}

//
// Grafana DNS Records
//
resource "aws_acm_certificate" "zabbix-app-prod-grafana" {
  domain_name               = var.zone_name-prod-grafana
  subject_alternative_names = ["*.${var.zone_name-prod-grafana}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dns_verify-prod-grafana" {
  for_each = {
    for dvo in aws_acm_certificate.zabbix-app-prod-grafana.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id-prod-grafana
}

resource "aws_acm_certificate_validation" "zabbix-app-prod-grafana" {
  certificate_arn         = aws_acm_certificate.zabbix-app-prod-grafana.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_verify-prod-grafana : record.fqdn]
}
