resource "aws_subnet" "private-1a" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block_1a
  availability_zone = var.availability_zone_1a

  tags = {
    Name = "${var.name_prefix}-private-1a"
  }
}

resource "aws_subnet" "private-1c" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block_1c
  availability_zone = var.availability_zone_1c

  tags = {
    Name = "${var.name_prefix}-private-1c"
  }
}

resource "aws_route_table" "private-1a" {
  vpc_id = var.vpc_id
}

resource "aws_route_table" "private-1c" {
  vpc_id = var.vpc_id
}

resource "aws_route_table_association" "private-1a" {
  subnet_id = aws_subnet.private-1a.id
  route_table_id = aws_route_table.private-1a.id
}

resource "aws_route_table_association" "private-1c" {
  subnet_id = aws_subnet.private-1c.id
  route_table_id = aws_route_table.private-1c.id
}
