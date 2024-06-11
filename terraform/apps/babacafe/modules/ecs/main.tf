resource "aws_ecs_cluster" "babacafe" {
  name = "${var.name_prefix}-cluster"
}

resource "aws_ecs_task_definition" "babacafe" {
  family                   = "${var.name_prefix}-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true
      portMappings = [{
        protocol      = "tcp"
        containerPort = 3000
        hostPort      = 3000
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region : "ap-northeast-1"
          awslogs-group : var.log_group_name
          awslogs-stream-prefix : "ecs"
        }
      },
      environment = var.env
    }
  ])
}

resource "aws_ecs_service" "babacafe" {
  name            = "${var.name_prefix}-service"
  cluster         = aws_ecs_cluster.babacafe.id
  task_definition = aws_ecs_task_definition.babacafe.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    security_groups = [aws_security_group.sg_ecs.id]
    subnets         = var.subnet_ids
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = 3000
  }
}

#
# http security group
#
resource "aws_security_group" "sg_ecs" {
  name        = "${var.name_prefix}-sg-ecs"
  description = "security group for ecs instance"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "sg_ecs" {
  security_group_id = aws_security_group.sg_ecs.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "sg_ecs" {
  security_group_id = aws_security_group.sg_ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}
