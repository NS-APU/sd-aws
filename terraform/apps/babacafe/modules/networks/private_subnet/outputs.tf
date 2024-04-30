output "subnet_ids" {
  value = [aws_subnet.app-1a.id, aws_subnet.app-1c.id]
}
