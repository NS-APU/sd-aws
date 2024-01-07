output "vpc_id" {
  value = aws_vpc.babacafe-vpc.id
}

output "private_subnet_id" {
  value = aws_subnet.private-subnet.id
}