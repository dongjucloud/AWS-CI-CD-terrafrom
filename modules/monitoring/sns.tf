### SNS Topic 생성 ###
resource "aws_sns_topic" "sns_topic" {
  name = "sns-topic"  
  display_name = "SNS Topic"  
}
### SNS 구독 생성 ###
resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = var.sns-topic-arn
  protocol  = "email"
  endpoint  = "dongju08@naver.com"  # 이메일 주소로 변경
}