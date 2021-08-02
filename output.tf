output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Name of created cluster"
  value       = local.cluster_name
}

output "ecr_url" {
  description = "URL of ECR registry"
  value       = aws_ecr_repository.ecr.repository_url
}

output "region" {
  description = "AWS region."
  value       = var.region
}
