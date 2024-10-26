data "aws_route53_zone" "host" {
  name = var.domain_name
}

//
// Production records
//

resource "aws_route53_zone" "zabbix-prod" {
  name = "zabbix.${var.domain_name}"
}

resource "aws_route53_record" "zabbix-prod" {
  type    = "A"
  name    = aws_route53_zone.zabbix-prod.name
  zone_id = aws_route53_zone.zabbix-prod.zone_id

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "zabbix-prod-ns" {
  type    = "NS"
  name    = aws_route53_zone.zabbix-prod.name
  zone_id = data.aws_route53_zone.host.id
  records = [
    aws_route53_zone.zabbix-prod.name_servers[0],
    aws_route53_zone.zabbix-prod.name_servers[1],
    aws_route53_zone.zabbix-prod.name_servers[2],
    aws_route53_zone.zabbix-prod.name_servers[3],
  ]
  ttl = 172800
}

resource "aws_route53_zone" "grafana-prod" {
  name = "grafana.${var.domain_name}"
}

resource "aws_route53_record" "grafana-prod" {
  type    = "A"
  name    = aws_route53_zone.grafana-prod.name
  zone_id = aws_route53_zone.grafana-prod.zone_id

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "grafana-prod-ns" {
  type    = "NS"
  name    = aws_route53_zone.grafana-prod.name
  zone_id = data.aws_route53_zone.host.id
  records = [
    aws_route53_zone.grafana-prod.name_servers[0],
    aws_route53_zone.grafana-prod.name_servers[1],
    aws_route53_zone.grafana-prod.name_servers[2],
    aws_route53_zone.grafana-prod.name_servers[3],
  ]
  ttl = 172800
}

//
// Staging records
//
