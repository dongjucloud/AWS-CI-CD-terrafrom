###ECR 생성 ###
resource "aws_ecr_repository" "my_ecr" {
  name = "my_ecr"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.ecr-tags
}


resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.my_ecr.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}