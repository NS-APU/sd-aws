data "aws_route53_zone" "host" {
  name = var.domain_name
}

//
// Production records
//

resource "aws_route53_zone" "zabbix-app-prod" {
  name = "zabbix-app.${var.domain_name}"
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

resource "aws_route53_zone" "zabbix-app-prod-api" {
  name = "api.zabbix-app.${var.domain_name}"
}

resource "aws_route53_record" "zabbix-app-prod-api" {
  type    = "A"
  name    = aws_route53_zone.zabbix-app-prod-api.name
  zone_id = aws_route53_zone.zabbix-app-prod-api.zone_id

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "zabbix-app-prod-api-ns" {
  type    = "NS"
  name    = aws_route53_zone.zabbix-app-prod-api.name
  zone_id = aws_route53_zone.zabbix-app-prod.zone_id
  records = [
    aws_route53_zone.zabbix-app-prod-api.name_servers[0],
    aws_route53_zone.zabbix-app-prod-api.name_servers[1],
    aws_route53_zone.zabbix-app-prod-api.name_servers[2],
    aws_route53_zone.zabbix-app-prod-api.name_servers[3],
  ]
  ttl = 172800
}

//
// Staging records
//

resource "aws_route53_zone" "zabbix-app-stag" {
  name = "zabbix-app-stag.${var.domain_name}"
}

resource "aws_route53_record" "zabbix-app-stag-ns" {
  type    = "NS"
  name    = aws_route53_zone.zabbix-app-stag.name
  zone_id = data.aws_route53_zone.host.id
  records = [
    aws_route53_zone.zabbix-app-stag.name_servers[0],
    aws_route53_zone.zabbix-app-stag.name_servers[1],
    aws_route53_zone.zabbix-app-stag.name_servers[2],
    aws_route53_zone.zabbix-app-stag.name_servers[3],
  ]
  ttl = 172800
}

resource "aws_route53_zone" "zabbix-app-stag-api" {
  name = "api.zabbix-app-stag.${var.domain_name}"
}

resource "aws_route53_record" "zabbix-app-stag-api" {
  type    = "A"
  name    = aws_route53_zone.zabbix-app-stag-api.name
  zone_id = aws_route53_zone.zabbix-app-stag-api.zone_id

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "zabbix-app-stag-api-ns" {
  type    = "NS"
  name    = aws_route53_zone.zabbix-app-stag-api.name
  zone_id = aws_route53_zone.zabbix-app-stag.zone_id
  records = [
    aws_route53_zone.zabbix-app-stag-api.name_servers[0],
    aws_route53_zone.zabbix-app-stag-api.name_servers[1],
    aws_route53_zone.zabbix-app-stag-api.name_servers[2],
    aws_route53_zone.zabbix-app-stag-api.name_servers[3],
  ]
  ttl = 172800
}

