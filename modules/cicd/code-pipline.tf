# 역할-pipe
resource "aws_iam_role" "pipe_role" {
  name = "pipe-role"
  assume_role_policy = data.aws_iam_policy_document.pipe_role.json
}
# 정책 - pipe
data "aws_iam_policy_document" "pipe_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    
    principals {
      type = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}
# policy-pipeline
resource "aws_iam_role_policy_attachment" "AWSCodePipeline_FullAccess" {
  role = aws_iam_role.pipe_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}
# policy-s3
resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
  role = aws_iam_role.pipe_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
# policy-commit 
resource "aws_iam_role_policy_attachment" "AWSCodeCommitFullAccess" {
  role = aws_iam_role.pipe_role.name 
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

resource "aws_iam_role_policy_attachment" "AWSCodeCommitReadOnly" {
  role = aws_iam_role.pipe_role.name 
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}
# policy-build
resource "aws_iam_role_policy_attachment" "AWSCodeBuildAdminAccess" {
  role = aws_iam_role.pipe_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}
# policy - CodeBuildReadOnlyAcces
resource "aws_iam_role_policy_attachment" "AWSCodeBuildReadOnlyAccess" {
  role = aws_iam_role.pipe_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildReadOnlyAccess"
}
# policy-ecs-task
resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy1" {
  role = aws_iam_role.pipe_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# policy-ecs-ecs
resource "aws_iam_role_policy_attachment" "AmazonECS_FullAccess1" {
  role = aws_iam_role.pipe_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
# policy-ecs-deploy
resource "aws_iam_role_policy_attachment" "AWSCodeDeployRoleForECS" {
  role = aws_iam_role.pipe_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}
### pipeline ###
resource "aws_codepipeline" "codepipeline" {
  name     = "test-pipeline"
  role_arn = aws_iam_role.pipe_role.arn
 
  artifact_store {
    location = var.s3-bucket
    type = "S3"
  }

  stage {
    name = "Source"
 
    action {
      name = "Source"
      category = "Source"
      owner = "AWS" 
      provider = "CodeCommit"
      version = "1"
      output_artifacts = ["source_output"]
 
      configuration = {
        RepositoryName = "MyCommitRepository"
        BranchName = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "MyBuildProject"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName = "my_cluster"
        ServiceName = "service"
        FileName = "imagedefinitions.json"
      }
    }
  }
}