data "aws_security_group" "default" {
  name = "default"
  vpc_id = var.vpc-id
}
### Codebuild ###
### 역할- Codebuild ###
resource "aws_iam_role" "codebuild_role" {
  name = "build-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_role.json
}
### 정책-codebuild ###
data "aws_iam_policy_document" "codebuild_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}
# policy-build
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}

resource "aws_iam_role_policy_attachment" "AdministratorAccess" {
  role = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# policy-ecr
resource "aws_iam_role_policy_attachment" "role_policy_attachment2" {
  role = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}
# policy-s3
resource "aws_iam_role_policy_attachment" "role_policy_attachment3" {
  role = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
# codecommnit
resource "aws_iam_role_policy_attachment" "CodeCommitFullAccess" {
  role = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}
# codepipeline 
resource "aws_iam_role_policy_attachment" "CodePipeline_FullAccess" {
  role = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}
# policy-ecs
resource "aws_iam_role_policy_attachment" "AmazonECS_FullAccess" {
  role = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
# policy-ecs-task 
resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy" {
  role = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
### codebuildproject ###
resource "aws_codebuild_project" "MyBuildProject" {
  name = "MyBuildProject"
  description = "code-build-project"
  service_role = aws_iam_role.codebuild_role.arn 
  
  artifacts {
    type = "S3"
    name = var.s3-id
    location = var.s3-bucket
    path = "/"
    packaging = "ZIP"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
  }

  vpc_config {
    vpc_id = var.vpc-id
    
    subnets = [
      var.pri-sub1-id,
      var.pri-sub2-id
    ]
    security_group_ids = [
      data.aws_security_group.default.id
    ]
  }

  source {
    type = "CODECOMMIT"
    location = var.code-repo-url
    buildspec = "buildspec.yml"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "Build-log-group"
      status = "ENABLED"
    }
  }
}