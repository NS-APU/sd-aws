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
        "name": "zabbix-server",
        "image": "980307435359.dkr.ecr.ap-northeast-1.amazonaws.com/zabbix-app-ecr-repo@sha256:568a9c5fb9947fe1ccc7ef05a051ce9e9c19bcdd3b9973a4f4158df82f8e5ea4",
        "cpu": 0,
        "portMappings": [
            {
                "name": "zabbix-server-10051-tcp",
                "containerPort": 10051,
                "hostPort": 10051,
                "protocol": "tcp"
            }
        ],
        "essential": true,
        "environment": [
            { name = "POSTGRES_USER", value = "zabbix" },
            { name = "POSTGRES_PASSWORD", value = "zabbix-app" },
            { name = "POSTGRES_DB", value = "zabbix" },
            { name = "DB_SERVER_HOST", value = "terraform-20241026094819845700000001.c7kkk4amyjm2.ap-northeast-1.rds.amazonaws.com" },
            { name = "DB_SERVER_PORT", "value = "5432" }
        ]
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/zabbix-app-production-zabbix-server",
                "mode": "non-blocking",
                "awslogs-create-group": "true",
                "max-buffer-size": "25m",
                "awslogs-region": "ap-northeast-1",
                "awslogs-stream-prefix": "ecs"
              }
            }
          },
          {
            "name": "zabbix-frontend",
            "image": "980307435359.dkr.ecr.ap-northeast-1.amazonaws.com/zabbix-app-ecr-repo@sha256:63fbd9a17dc483abb20e915112226aa4129dd43f80c0d191e2ad5894e7df07b9",
            "cpu": 0,
            "portMappings": [
            {
              "name": "zabbix-frontend-8080-tcp",
              "containerPort": 8080,
              "hostPort": 8080,
              "protocol": "tcp"
            },
            {
              "name": "zabbix-frontend-8443-tcp",
              "containerPort": 8443,
              "hostPort": 8443,
              "protocol": "tcp"
            }
            ],
            "essential": false,
            "environment": [
            { name = "POSTGRES_USER", value = "zabbix" },
            { name = "DB_SERVER_HOST", value =  "terraform-20241026094819845700000001.c7kkk4amyjm2.ap-northeast-1.rds.amazonaws.com" },
            { name = "ZBX_SERVER_HOST", value = "localhost:10051" },
            { name = "POSTGRES_PASSWORD", value = "zabbix-app" },
            { name = "POSTGRES_DB", value = "zabbix" },
            { name = "ZBX_SERVER_PORT", value = "10051" },
            { name = "PHP_TZ", value = "Asia/Tokyo" }
            ]
            "logConfiguration": {
              "logDriver": "awslogs",
              "options": {
                "awslogs-group": "/ecs/zabbix-app-production-zabbix-frontend",
                "mode": "non-blocking",
                "awslogs-create-group": "true",
                "max-buffer-size": "25m",
                "awslogs-region": "ap-northeast-1",
                "awslogs-stream-prefix": "ecs"
              },
            },
          },
      {
        "name": "grafana",
        "image": "980307435359.dkr.ecr.ap-northeast-1.amazonaws.com/zabbix-app-ecr-repo:latest",
        "cpu": 0,
        "portMappings": [
        {
          "name": "grafana-3000-tcp",
          "containerPort": 3000,
          "hostPort": 3000,
          "protocol": "tcp"
        }
        ],
        "essential": false,
        "environment": [
        { name = "GF_SECURIT_ADMIN_USER", value = "admin" },
        { name = "GF_SECURITY_ADMIN_PASSWORD", value = "12345" },
        { name = "TZ", value = "Asia/Tokyo" }
        ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "/ecs/zabbix-app-production-grafana",
            "mode": "non-blocking",
            "awslogs-create-group": "true",
            "max-buffer-size": "25m",
            "awslogs-region": "ap-northeast-1",
            "awslogs-stream-prefix": "ecs"
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

  network_configuration {
    security_groups = [aws_security_group.sg_ecs.id]
    subnets         = var.subnet_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.grafana-app.arn 
    container_name   = "grafana"
    container_port   = 3000
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.zabbix-app.arn
    contianer_name   = "zabbix-frontend"
    container_port   = 8080
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
