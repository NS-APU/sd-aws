data "aws_route53_zone" "host" {
  name = var.domain_name
}

//
// Production records
//

resource "aws_route53_zone" "pokeapp-prod" {
  name = "pokeapp.${var.domain_name}"
}

resource "aws_route53_record" "pokeapp-prod-ns" {
  type    = "NS"
  name    = aws_route53_zone.pokeapp-prod.name
  zone_id = data.aws_route53_zone.host.id
  records = [
    aws_route53_zone.pokeapp-prod.name_servers[0],
    aws_route53_zone.pokeapp-prod.name_servers[1],
    aws_route53_zone.pokeapp-prod.name_servers[2],
    aws_route53_zone.pokeapp-prod.name_servers[3],
  ]
  ttl = 172800
}

resource "aws_route53_zone" "pokeapp-prod-api" {
  name = "api.pokeapp.${var.domain_name}"
}

resource "aws_route53_record" "pokeapp-prod-api" {
  type    = "A"
  name    = aws_route53_zone.pokeapp-prod-api.name
  zone_id = aws_route53_zone.pokeapp-prod-api.zone_id

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "pokeapp-prod-api-ns" {
  type    = "NS"
  name    = aws_route53_zone.pokeapp-prod-api.name
  zone_id = aws_route53_zone.pokeapp-prod.zone_id
  records = [
    aws_route53_zone.pokeapp-prod-api.name_servers[0],
    aws_route53_zone.pokeapp-prod-api.name_servers[1],
    aws_route53_zone.pokeapp-prod-api.name_servers[2],
    aws_route53_zone.pokeapp-prod-api.name_servers[3],
  ]
  ttl = 172800
}

//
// Staging records
//

resource "aws_route53_zone" "pokeapp-stag" {
  name = "pokeapp-stag.${var.domain_name}"
}

resource "aws_route53_record" "pokeapp-stag-ns" {
  type    = "NS"
  name    = aws_route53_zone.pokeapp-stag.name
  zone_id = data.aws_route53_zone.host.id
  records = [
    aws_route53_zone.pokeapp-stag.name_servers[0],
    aws_route53_zone.pokeapp-stag.name_servers[1],
    aws_route53_zone.pokeapp-stag.name_servers[2],
    aws_route53_zone.pokeapp-stag.name_servers[3],
  ]
  ttl = 172800
}

resource "aws_route53_zone" "pokeapp-stag-api" {
  name = "api.pokeapp-stag.${var.domain_name}"
}

resource "aws_route53_record" "pokeapp-stag-api" {
  type    = "A"
  name    = aws_route53_zone.pokeapp-stag-api.name
  zone_id = aws_route53_zone.pokeapp-stag-api.zone_id

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "pokeapp-stag-api-ns" {
  type    = "NS"
  name    = aws_route53_zone.pokeapp-stag-api.name
  zone_id = aws_route53_zone.pokeapp-stag.zone_id
  records = [
    aws_route53_zone.pokeapp-stag-api.name_servers[0],
    aws_route53_zone.pokeapp-stag-api.name_servers[1],
    aws_route53_zone.pokeapp-stag-api.name_servers[2],
    aws_route53_zone.pokeapp-stag-api.name_servers[3],
  ]
  ttl = 172800
}

