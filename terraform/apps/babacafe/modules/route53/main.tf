data "aws_route53_zone" "host" {
  name = var.domain_name
}

resource "aws_route53_zone" "babacafe-prod" {
  name = "babacafe.${var.domain_name}"

  tags = {
    env = "product"
  }
}

resource "aws_route53_record" "babacafe-prod" {
  type = "A"
  name = aws_route53_zone.babacafe-prod.name
  zone_id = aws_route53_zone.babacafe-prod.zone_id

  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }
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

resource "aws_route53_zone" "babacafe-stag" {
  name = "stag.babacafe.${var.domain_name}"

  tags = {
    env = "staging"
  }
}

resource "aws_route53_record" "babacafe-stag" {
  type = "A"
  name = aws_route53_zone.babacafe-stag.name
  zone_id = aws_route53_zone.babacafe-stag.zone_id

  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "babacafe-stag-ns" {
  type = "NS"
  name = aws_route53_zone.babacafe-stag.name
  zone_id = aws_route53_zone.babacafe-prod.zone_id
  records = [
    aws_route53_zone.babacafe-stag.name_servers[0],
    aws_route53_zone.babacafe-stag.name_servers[1],
    aws_route53_zone.babacafe-stag.name_servers[2],
    aws_route53_zone.babacafe-stag.name_servers[3],
  ]
  ttl = 172800
}