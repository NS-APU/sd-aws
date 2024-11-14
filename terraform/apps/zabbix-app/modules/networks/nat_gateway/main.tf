#
# EIP
#

resource "aws_eip" "nat_gw_eip" {
  domain   = "vpc"
}

#
# NAT Gateway
#

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = var.subnet_id
}