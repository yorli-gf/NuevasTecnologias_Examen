# Repositorio ECR
resource "aws_ecr_repository" "repo_gonzalez" {
  name                 = "repo-${var.project_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = { Name = "ecr-${var.project_name}" }
}
