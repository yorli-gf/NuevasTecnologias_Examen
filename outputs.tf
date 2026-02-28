output "alb_dns_name" {
  description = "DNS del Application Load Balancer"
  value       = aws_lb.alb_gonzalez.dns_name
}

output "ecr_repository_url" {
  description = "URL del repositorio ECR"
  value       = aws_ecr_repository.repo_gonzalez.repository_url
}
