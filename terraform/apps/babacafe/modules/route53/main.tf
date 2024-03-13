resource "aws_route53_zone" "babacafe-prod" {
  name = "babacafe.${var.domain_name}"
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

resource "aws_route53_zone" "babacafe-staging" {
  name = "stag.babacafe.${var.domain_name}"
}

resource "aws_route53_record" "babacafe-staging" {
  type = "A"
  name = aws_route53_zone.babacafe-staging.name
  zone_id = aws_route53_zone.babacafe-staging.zone_id

  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }
}