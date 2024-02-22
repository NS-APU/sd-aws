output "vpc_id" {
  value = aws_vpc.babacafe-vpc.id
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}

output "sg_ingress_allow_https_port_id" {
  value = aws_vpc_security_group_ingress_rule.allow_https_port.id
}

output "sg_ingress_allow_rds_port_id" {
  value = aws_vpc_security_group_ingress_rule.allow_rds_port.id
}

output "sg_egress_allow_all" {
  value = aws_vpc_security_group_egress_rule.outbound_allow_all.id
}