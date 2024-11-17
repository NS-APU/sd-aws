resource "aws_ecs_cluster" "zabbix-app" {
  name = "${var.name_prefix}-cluster"
}

resource "aws_ecs_task_definition" "zabbix-app" {
  family                   = "${var.name_prefix}-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
        name = var.container_name_1
        image = var.container_image_1
        portMappings = [
            {
               containerPort = 10051
               hostPort = 10051
               protocol = "tcp"
            }]
        essential = true
        environment = var.env_zabbix_server
        logConfiguration = {
             logDriver = "awslogs",
             options = {
                awslogs-group = "/ecs/zabbix-app-production-zabbix-server"
                awslogs-region = "ap-northeast-1",
                awslogs-stream-prefix = "ecs"
              }
            }
          },
          {
            name = var.container_name_2
            image = var.container_image_2
            portMappings = [
            {
              name = "zabbix-frontend-8080-tcp"
              containerPort = 8080
              hostPort = 8080
              protocol = "tcp"
            },
            {
              name = "zabbix-frontend-8443-tcp"
              containerPort = 8443
              hostPort = 8443
              protocol = "tcp"
            }
            ]
            essential = false
            environment = var.env_zabbix_frontend 
            logConfiguration = {
              logDriver = "awslogs"
              options = {
                awslogs-group = "/ecs/zabbix-app-production-zabbix-frontend",               awslogs-region = "ap-northeast-1"
                awslogs-stream-prefix = "ecs"
              }
            },
          },
      {
        name = var.container_name_3
        image = var.container_image_3
        portMappings = [
        {
          containerPort = 3000
          hostPort = 3000
          protocol = "tcp"
        }
        ],
        essential = false,
        enviroment = var.env_grafana
        logConfiguration = {
          logDriver = "awslogs",
          options = {
            awslogs-group = "/ecs/zabbix-app-production-grafana"
            awslogs-region = "ap-northeast-1"
            awslogs-stream-prefix = "ecs"
          },
        },
      }
  ])
}

resource "aws_ecs_service" "zabbix-app" {
  name            = "${var.name_prefix}-service"
  cluster         = aws_ecs_cluster.zabbix-app.id
  task_definition = aws_ecs_task_definition.zabbix-app.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  force_new_deployment = true

  network_configuration {
    security_groups = [aws_security_group.sg_ecs.id]
    subnets         = var.subnet_ids
  }

  load_balancer {
    target_group_arn = var.target_group_arn_grafana 
    container_name   = "grafana"
    container_port   = 3000
  }

  load_balancer {
    target_group_arn = var.target_group_arn_zabbix
    container_name   = "zabbix-frontend"
    container_port   = 8080
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

resource "aws_vpc_security_group_ingress_rule" "sg_ecs_grafana" {
  security_group_id = aws_security_group.sg_ecs.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "sg_ecs_zabbix" {
  security_group_id = aws_security_group.sg_ecs.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "sg_ecs" {
  security_group_id = aws_security_group.sg_ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}
