resource "aws_internet_gateway" "pokeapp" {
  vpc_id = var.vpc_id
}