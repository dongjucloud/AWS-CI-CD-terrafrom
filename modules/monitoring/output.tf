output "cloudwatch-log-name" {
  description = "cloudwatch-log-name"
  value = aws_cloudwatch_log_group.log-group.name
}
output "cloudwatch-log-stream-name" {
  description = "cloudwatch-log-steram"
  value = aws_cloudwatch_log_stream.log-stream.name 
}
output "sns-topic-arn" {
  description = "cloudwatch-log-steram"
  value = aws_sns_topic.sns_topic.arn
}
