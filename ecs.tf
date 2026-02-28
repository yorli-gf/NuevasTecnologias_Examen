# Cluster ECS
resource "aws_ecs_cluster" "cluster_gonzalez" {
  name = "cluster-${var.project_name}"
  tags = { Name = "cluster-${var.project_name}" }
}

# SG para las tareas de ECS (Fargate)
resource "aws_security_group" "ecs_sg_gonzalez" {
  name        = "ecs-sg-${var.project_name}"
  description = "Permitir trafico desde el ALB"
  vpc_id      = aws_vpc.vpc_gonzalez.id

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg_gonzalez.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-ecs-${var.project_name}" }
}

# Task Definition
resource "aws_ecs_task_definition" "task_gonzalez" {
  family                   = "task-${var.project_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role_gonzalez.arn

  container_definitions = jsonencode([
    {
      name      = "app-${var.project_name}"
      image     = "${aws_ecr_repository.repo_gonzalez.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "service_gonzalez" {
  name            = "service-${var.project_name}"
  cluster         = aws_ecs_cluster.cluster_gonzalez.id
  task_definition = aws_ecs_task_definition.task_gonzalez.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_1_gonzalez.id, aws_subnet.private_2_gonzalez.id]
    security_groups  = [aws_security_group.ecs_sg_gonzalez.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_gonzalez.arn
    container_name   = "app-${var.project_name}"
    container_port   = 8000
  }

  depends_on = [aws_lb_listener.listener_gonzalez]
}
