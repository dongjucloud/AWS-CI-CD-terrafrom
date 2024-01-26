### Codecommit ###
### Codecommit-repository ###
resource "aws_codecommit_repository" "MyCommitRepository" {
  repository_name = "MyCommitRepository"
  description = "Repository for CodeCommit"
}
