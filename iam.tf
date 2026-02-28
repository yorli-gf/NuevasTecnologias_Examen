# ECS Task Execution Role
resource "aws_iam_role" "ecs_execution_role_gonzalez" {
  name = "ecs-execution-role-${var.project_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  tags = { Name = "iam-role-${var.project_name}" }
}

# Adjuntar política estándar de ejecución de ECS
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy_gonzalez" {
  role       = aws_iam_role.ecs_execution_role_gonzalez.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
