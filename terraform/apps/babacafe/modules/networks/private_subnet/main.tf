resource "aws_subnet" "app" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block
}

resource "aws_route_table" "app" {
  vpc_id = var.vpc_id
}

resource "aws_route_table_association" "app" {
  subnet_id = aws_subnet.app.id
  route_table_id = aws_route_table.app.id
}