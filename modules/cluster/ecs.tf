### ECS 역할 정책 ###
### 정책-task ###
data "aws_iam_policy_document" "ecs_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
### 역할-task ###
resource "aws_iam_role" "ecs_role" {
  name = "ecs-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_role.json
}
### Policy-ECS ###
resource "aws_iam_role_policy_attachment" "AmazonECS_FullAccess" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
### Policy-ECS-Task ###
resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
### Policy-S3 ###
resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
### Policy - cloudwatch_logs ###
resource "aws_iam_role_policy_attachment" "CloudWatchLogsFullAccess" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
resource "aws_iam_role_policy_attachment" "CloudWatchReadOnlyAccess" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "AmazonAPIGatewayPushToCloudWatchLogs" {
  role = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

### ECS 생성 ###
### ECS_Task_Definition ###
resource "aws_ecs_task_definition" "service" {
  family = "service" 
  network_mode = "awsvpc" 
  execution_role_arn = aws_iam_role.ecs_role.arn
  cpu = 256 
  memory = 512 
  requires_compatibilities = ["FARGATE"] 
  task_role_arn = aws_iam_role.ecs_role.arn
  container_definitions = jsonencode([
      {
      "name": "service",
      "image": "${var.ecr-url}",  

      "cpu": 256,
      "memory": 512,
      "essential": true,
      "portMappings": [
        {
          "name": "serivce-80-tcp",
          "containerPort": 80,
          "hostPort": 80,
          "appProtocol": "http"
        }
      ],
      "logconfiguration" : {
          "logdriver" : "awslogs",
          "options"    : {
            "awslogs-group"         : "${var.log-group}",
            "awslogs-region"        : "us-east-2",
            "awslogs-stream-prefix" : "${var.log-stream}",
        }
      } 
    }
  ])
  runtime_platform {
  operating_system_family = "LINUX"
  cpu_architecture = "X86_64"
 }
}
### ECS Cluster ###
resource "aws_ecs_cluster" "ECS_Cluster" {
  name = "my_cluster" 

    setting {
    name  = "containerInsights"
   
    value = "enabled"
  }
}
### ECS service ###
resource "aws_ecs_service" "ECS-Service" {
  name = "service" 
  cluster = aws_ecs_cluster.ECS_Cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  launch_type = "FARGATE"
  desired_count = 1

  network_configuration {
  security_groups = [aws_security_group.SG_alb.id]  
  subnets = [
  var.pri-sub1-id,
  var.pri-sub2-id
  ]
  assign_public_ip = true
  }

  load_balancer {
  target_group_arn = aws_lb_target_group.ALB-TG.arn
  container_name = aws_ecs_task_definition.service.family
  container_port = 80
  }
}
### LB 구성 ####
### 보안그룹 - ALB ###
resource "aws_security_group" "SG_alb" {
  name = "WEBSG"
  description = "Allow HTTP(80/tcp, 8080/tcp)"
  vpc_id = var.vpc-id
  ingress {
  description = "Allow HTTP(80)"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
  description = "Allow HTTPs(8080)"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
  Name = "SG_alb"
  }
}
### ALB 생성 ###
resource "aws_lb" "ALB" {
  name = "myALB"
  load_balancer_type = "application"
  subnets = [
  var.pub-sub1-id,
  var.pub-sub2-id
  ]
 security_groups = [aws_security_group.SG_alb.id]
}
### ALB Listner 생성 ###
resource "aws_lb_listener" "ALB-Listener" {
  load_balancer_arn = aws_lb.ALB.arn
  port = 80
  protocol = "HTTP"
  default_action {
  type = "forward"
  target_group_arn = aws_lb_target_group.ALB-TG.arn
  }
}
### Tagret Group 생성 ###
resource "aws_lb_target_group" "ALB-TG" {
  name = "myALB-TG"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.vpc-id
}



