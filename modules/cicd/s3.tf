### S3 역할 & 정책###
### S3 역할 ###
resource "aws_iam_role" "s3-role" {
  name = "s3-role"
  assume_role_policy = data.aws_iam_policy_document.s3-role.json
}
### S3 정책 ###
data "aws_iam_policy_document" "s3-role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    
    principals {
      type = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}
### Policy-S3 ###
resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess2" {
  role = aws_iam_role.s3-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
### S3 생성 ###
resource "aws_s3_bucket" "Mys3" {
  bucket = "mys3-8596"
}