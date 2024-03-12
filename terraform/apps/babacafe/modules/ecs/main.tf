resource "aws_ecs_cluster" "babacafe" {
  name = "${var.name_prefix}-cluster"
}

resource "aws_ecs_task_definition" "babacafe" {
  family = "${var.name_prefix}-def"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = var.cpu
  memory = var.memory

  container_definitions = file(var.task_definition_path)
}

resource "aws_ecs_service" "babacafe" {
  name = "${var.name_prefix}-service"
  cluster = aws_ecs_cluster.babacafe.id
  task_definition = aws_ecs_task_definition.babacafe.arn

  network_configuration {
    security_groups = [aws_security_group.sg_allow_http.id]
    subnets = var.subnet_ids
  }
}

#
# http security group
#
resource "aws_security_group" "sg_allow_http" {
  name = "sg_allow_http"
  description = "allow http port"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "sg_allow_http" {
  security_group_id = aws_security_group.sg_allow_http.id
  cidr_ipv4 = var.vpc_cidr_block
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "sg_allow_http" {
  security_group_id = aws_security_group.sg_allow_https.id
  cidr_ipv4 = var.vpc_cidr_block
  ip_protocol = -1
}