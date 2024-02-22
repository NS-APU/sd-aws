resource "aws_lb" "alb" {
  load_balancer_type = "application"
  name               = var.alb_name

  security_groups = var.alb_security_groups
  subnets = var.alb_subnet_ids
}