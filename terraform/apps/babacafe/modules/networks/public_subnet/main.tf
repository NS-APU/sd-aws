resource "aws_subnet" "alb_1a" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block_1a
  availability_zone = var.availability_zone_1a
  map_public_ip_on_launch = true
}

resource "aws_subnet" "alb_1c" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block_1c
  availability_zone = var.availability_zone_1c
  map_public_ip_on_launch = true
}

resource "aws_route_table" "alb_1a" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
}

resource "aws_route_table" "alb_1c" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
}

resource "aws_route_table_association" "alb_1a" {
  subnet_id = aws_subnet.alb_1a.id
  route_table_id = aws_route_table.alb_1a.id
}

resource "aws_route_table_association" "alb_1c" {
  subnet_id = aws_subnet.alb_1c.id
  route_table_id = aws_route_table.alb_1c.id
}