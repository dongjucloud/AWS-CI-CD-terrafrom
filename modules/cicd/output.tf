output "s3_url" {
  description = "s3-url"
  value = aws_s3_bucket.Mys3.arn
}
output "s3_id" {
  description = "s3-name"
  value = aws_s3_bucket.Mys3.id
}
output "s3_bucket" {
  description = "s3 bucket"
  value = aws_s3_bucket.Mys3.bucket
}
output "code_repo_url" {
  description = "Code Commit Repository URL"
  value = aws_codecommit_repository.MyCommitRepository.clone_url_http
}
output "code_build_id" {
  description = "Code Build Project Name"
  value = aws_codebuild_project.MyBuildProject
}
/*
output "log_group_id" {
  description = "cloudwatch_log_group Name"
  value = aws_cloudwatch_log_group.log-group.name
}
*/
