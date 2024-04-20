output "vpc_id" {
  value = aws_vpc.babacafe-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.babacafe-vpc.cidr_block
}
