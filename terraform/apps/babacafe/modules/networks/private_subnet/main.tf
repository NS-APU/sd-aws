resource "aws_subnet" "app-1a" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block_1a
  availability_zone = var.availability_zone_1a
}

resource "aws_subnet" "app-1c" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block_1c
  availability_zone = var.availability_zone_1c
}

resource "aws_route_table" "app-1a" {
  vpc_id = var.vpc_id
}

resource "aws_route_table" "app-1c" {
  vpc_id = var.vpc_id
}

resource "aws_route_table_association" "app-1a" {
  subnet_id = aws_subnet.app-1a.id
  route_table_id = aws_route_table.app-1a.id
}

resource "aws_route_table_association" "app-1c" {
  subnet_id = aws_subnet.app-1c.id
  route_table_id = aws_route_table.app-1c.id
}
