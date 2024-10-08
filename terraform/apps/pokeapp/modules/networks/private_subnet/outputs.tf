output "subnet_ids" {
  value = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]
}

output "route_table_1a_id" {
  value = aws_route_table.private-1a.id
}

output "route_table_1c_id" {
  value = aws_route_table.private-1c.id
}