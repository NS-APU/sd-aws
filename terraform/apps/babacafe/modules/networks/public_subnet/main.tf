resource "aws_subnet" "alb" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block
}

resource "aws_route_table" "alb" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
}

resource "aws_route_table_association" "alb" {
  subnet_id = aws_subnet.alb.id
  route_table_id = aws_route_table.alb.id
}