# TODO: 定義をすべてこっちに持ってくる(e.g. albの名前とか)

locals {
  name_prefix = "babacafe"

  domain_name = "systemdesign-apu.com"

  vpc_cidr_block           = "10.0.0.0/16"
  alb_subnet_cidr_block_1a = "10.0.1.0/24"
  alb_subnet_cidr_block_1c = "10.0.2.0/24"
  availability_zone_1a     = "ap-northeast-1a"
  availability_zone_1c     = "ap-northeast-1c"
}
