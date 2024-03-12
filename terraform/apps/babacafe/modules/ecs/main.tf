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
    security_groups = var.security_group_ids
    subnets = var.subnet_ids
  }
}