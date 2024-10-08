output "subnet_ids" {
  value = [aws_subnet.alb_1a.id, aws_subnet.alb_1c.id]
}