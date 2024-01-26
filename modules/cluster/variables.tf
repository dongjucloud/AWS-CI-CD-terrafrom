variable "ecr-url" {
  description = "ECR-URL"
  type = string
}
variable "pri-sub1-id" {
  description = "Pri-Sub1 ID"
  type = string
}
variable "pri-sub2-id" {
  description = "Pri-Sub2 ID"
  type = string
}
variable "pub-sub1-id" {
  description = "Pub-Sub1 ID"
  type = string
}
variable "pub-sub2-id" {
  description = "Pri-Sub2 ID"
  type = string
}
variable "vpc-id" {
  description = "VPC ID"
  type = string
}
variable "ecr-tags" {
  description = "ECR tags"
  type = map(string)
  default = { Name = "ecr" }
}
variable "log-group" {
  description = "cloudwatch log group ID"
  type = string 
}
variable "log-stream" {
  description = "cloudwatch log stream ID"
  type = string 
}
