resource "aws_internet_gateway" "babacafe_igw" {
  vpc_id = var.vpc_id
}