output "certificate_arn-prod" {
  value = aws_acm_certificate.babacafe.arn
}

output "certificate_arn-stag" {
  value = aws_acm_certificate.babacafe-stag.arn
}
