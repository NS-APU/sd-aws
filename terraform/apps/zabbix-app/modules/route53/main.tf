data "aws_route53_zone" "host" {
  name = var.domain_name
}

//
// Production records
//

resource "aws_route53_zone" "zabbix-app-prod" {
  name = "zabbix.${var.domain_name}"
}

resource "aws_route53_record" "zabbix-app-prod-ns" {
  type    = "NS"
  name    = aws_route53_zone.zabbix-app-prod.name
  zone_id = data.aws_route53_zone.host.id
  records = [
    aws_route53_zone.zabbix-app-prod.name_servers[0],
    aws_route53_zone.zabbix-app-prod.name_servers[1],
    aws_route53_zone.zabbix-app-prod.name_servers[2],
    aws_route53_zone.zabbix-app-prod.name_servers[3],
  ]
  ttl = 172800
}

resource "aws_route53_zone" "grafana-app-prod" {
  name = "grafana-app.${var.domain_name}"
}

resource "aws_route53_record" "grafana-app-prod" {
  type    = "A"
  name    = aws_route53_zone.grafana-app-prod.name
  zone_id = aws_route53_zone.grafana-app-prod.zone_id

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "grafana-app-prod-ns" {
  type    = "NS"
  name    = aws_route53_zone.grafana-app-prod.name
  zone_id = aws_route53_zone.grafana-app-prod.zone_id
  records = [
    aws_route53_zone.grafana-app-prod.name_servers[0],
    aws_route53_zone.grafana-app-prod.name_servers[1],
    aws_route53_zone.grafana-app-prod.name_servers[2],
    aws_route53_zone.grafana-app-prod.name_servers[3],
  ]
  ttl = 172800
}

//
// Staging records
//
