resource "aws_acm_certificate" "babacafe" {
  domain_name               = var.zone_name-prod
  subject_alternative_names = ["*.${var.zone_name-prod}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dns_verify" {
  for_each = {
    for dvo in aws_acm_certificate.babacafe.domain_validation_options : dvo.domain_name => {
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
  zone_id         = var.zone_id-prod
}

resource "aws_acm_certificate_validation" "babacafe" {
  certificate_arn         = aws_acm_certificate.babacafe.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_verify : record.fqdn]
}

resource "aws_acm_certificate" "babacafe-stag" {
  domain_name               = var.zone_name-stag
  subject_alternative_names = ["*.${var.zone_name-stag}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dns_verify-stag" {
  for_each = {
    for dvo in aws_acm_certificate.babacafe-stag.domain_validation_options : dvo.domain_name => {
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
  zone_id         = var.zone_id-stag
}

resource "aws_acm_certificate_validation" "babacafe-stag" {
  certificate_arn         = aws_acm_certificate.babacafe-stag.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_verify-stag : record.fqdn]
}
