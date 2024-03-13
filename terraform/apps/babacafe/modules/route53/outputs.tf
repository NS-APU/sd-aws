output "zone_name-prod" {
  value = aws_route53_zone.babacafe-prod.name
}

output "zone_name-stag" {
  value = aws_route53_zone.babacafe-stag.name
}

output "zone_id-prod" {
  value = aws_route53_zone.babacafe-prod.id
}