output "dns_name" {
  description = "ALB DNS Name"
  value = aws_lb.ALB.dns_name
}
output "ecr_name" {
  description = "ECR NAME"
  value = aws_ecr_repository.my_ecr.name
}
output "ecr_url" {
  description = "ECR NAME"
  value = aws_ecr_repository.my_ecr.repository_url
}
output "ecs-cluster-name" {
  description = "ECS CLUSTER NAME"
  value = aws_ecs_cluster.ECS_Cluster.name
}
output "ecs-service-name" {
  description = "ECS SERVICE NAME"
  value = aws_ecs_service.ECS-Service.name
}

