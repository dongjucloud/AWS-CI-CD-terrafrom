### CloudWatch Dashboard ###
resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "ecs-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", var.ecs-service-name, "ClusterName", var.ecs-cluster-name, {stat = "Average"}],
            [".", "MemoryUtilization", ".", ".", ".", ".", {stat = "Average"}]
          ],
        region = "us-east-2"
        annotations = {
          horizontal = [
          {
            color = "#ff9896",
            label = "100% CPU",
            value = 100
          },
          {
            color = "#9edae5",
            label = "100% Memory",
            value = 100,
            yAxis = "right"
          },
        ]
      }
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
          period = 300,
          title  = "ECS Service Metrics",
        },
      },
    ],
  })
}
### CloudWatch Log-group & log-stream
resource "aws_cloudwatch_log_group" "log-group" {
  name              = "task-log-group"
  retention_in_days = "14"
}
resource "aws_cloudwatch_log_stream" "log-stream" {
  name           = "log-stream"
  log_group_name = aws_cloudwatch_log_group.log-group.name
}
### ECS CloudAlarm metric - CPU ###
resource "aws_cloudwatch_metric_alarm" "ecs_service_cpu_alarm" {
  alarm_name          = "ecs-service-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 40
  actions_enabled     = true
  alarm_description   = "This will alarm if ECS service CPU utilization is greater than or equal to 80%"

  dimensions = {
    ServiceName = var.ecs-service-name
    ClusterName = var.ecs-cluster-name
  }
  alarm_actions = [var.sns-topic-arn]
}
### ECS CloudAlarm metric - Memory ###
resource "aws_cloudwatch_metric_alarm" "ecs_service_memory_alarm" {
  alarm_name          = "ecs-service-memory-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 40
  actions_enabled     = true
  alarm_description   = "This will alarm if ECS service memory utilization is greater than or equal to 80%"

  dimensions = {
    ServiceName = var.ecs-service-name
    ClusterName = var.ecs-cluster-name
  }
  alarm_actions = [var.sns-topic-arn]
}
