output "vpc_id" {
  value = aws_vpc.pokeapp-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.pokeapp-vpc.cidr_block
}
