output "certificate_arn-prod" {
  value = aws_acm_certificate.pokeapp.arn
}

output "certificate_arn-stag" {
  value = aws_acm_certificate.pokeapp-stag.arn
}
