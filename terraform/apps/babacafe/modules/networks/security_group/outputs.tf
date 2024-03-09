output "sg_allow_https" {
  value = aws_security_group.sg_allow_https.id
}

output "sg_allow_psql" {
  value = aws_security_group.sg_allow_psql.id
}
