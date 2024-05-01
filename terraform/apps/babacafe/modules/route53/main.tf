data "aws_route53_zone" "host" {
  name = var.domain_name
}

//
// Production records
//

resource "aws_route53_zone" "babacafe-prod" {
  name = "babacafe.${var.domain_name}"
}

resource "aws_route53_record" "babacafe-prod-ns" {
  type = "NS"
  name = aws_route53_zone.babacafe-prod.name
  zone_id = data.aws_route53_zone.host.id
  records = [
    aws_route53_zone.babacafe-prod.name_servers[0],
    aws_route53_zone.babacafe-prod.name_servers[1],
    aws_route53_zone.babacafe-prod.name_servers[2],
    aws_route53_zone.babacafe-prod.name_servers[3],
  ]
  ttl = 172800
}

resource "aws_route53_zone" "babacafe-prod-api" {
  name = "api.babacafe.${var.domain_name}"
}

resource "aws_route53_record" "babacafe-prod-api" {
  type = "A"
  name = aws_route53_zone.babacafe-prod-api.name
  zone_id = aws_route53_zone.babacafe-prod-api.zone_id

  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "babacafe-prod-api-ns" {
  type = "NS"
  name = aws_route53_zone.babacafe-prod-api.name
  zone_id = aws_route53_zone.babacafe-prod.zone_id
  records = [
    aws_route53_zone.babacafe-prod-api.name_servers[0],
    aws_route53_zone.babacafe-prod-api.name_servers[1],
    aws_route53_zone.babacafe-prod-api.name_servers[2],
    aws_route53_zone.babacafe-prod-api.name_servers[3],
  ]
  ttl = 172800
}

//
// Staging records
//

resource "aws_route53_zone" "babacafe-stag" {
  name = "babacafe-stag.${var.domain_name}"
}

resource "aws_route53_record" "babacafe-stag-ns" {
  type = "NS"
  name = aws_route53_zone.babacafe-stag.name
  zone_id = data.aws_route53_zone.host.id
  records = [
    aws_route53_zone.babacafe-stag.name_servers[0],
    aws_route53_zone.babacafe-stag.name_servers[1],
    aws_route53_zone.babacafe-stag.name_servers[2],
    aws_route53_zone.babacafe-stag.name_servers[3],
  ]
  ttl = 172800
}

resource "aws_route53_zone" "babacafe-stag-api" {
  name = "api.babacafe-stag.${var.domain_name}"
}

resource "aws_route53_record" "babacafe-stag-api" {
  type = "A"
  name = aws_route53_zone.babacafe-stag-api.name
  zone_id = aws_route53_zone.babacafe-stag-api.zone_id

  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "babacafe-stag-api-ns" {
  type = "NS"
  name = aws_route53_zone.babacafe-stag-api.name
  zone_id = aws_route53_zone.babacafe-stag.zone_id
  records = [
    aws_route53_zone.babacafe-stag-api.name_servers[0],
    aws_route53_zone.babacafe-stag-api.name_servers[1],
    aws_route53_zone.babacafe-stag-api.name_servers[2],
    aws_route53_zone.babacafe-stag-api.name_servers[3],
  ]
  ttl = 172800
}

