resource "aws_lb" "alb" {
  name               = "alb"
  load_balancer_type = "application"
}