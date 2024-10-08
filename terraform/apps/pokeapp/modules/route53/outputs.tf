output "zone_name-prod" {
  value = aws_route53_zone.pokeapp-prod.name
}

output "zone_name-stag" {
  value = aws_route53_zone.pokeapp-stag.name
}

output "zone_id-prod" {
  value = aws_route53_zone.pokeapp-prod.id
}

output "zone_id-stag" {
  value = aws_route53_zone.pokeapp-stag.id
}
