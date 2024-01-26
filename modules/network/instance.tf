### keypair ###
resource "aws_key_pair" "testkey" {
  key_name   = "testkey"
  public_key = file("~/.ssh/testkey.pub")
}

### 보안그룹 - instance ###
resource "aws_security_group" "SG_instance" {
  name = "SG_instance"
  description = "Allow HTTP(80/tcp, 8080/tcp), ssh(22/tcp)"
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

  ingress {
  description = "Allow ssh(22)"
  from_port = 22
  to_port = 22
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
  Name = "SG_instance"
  }
}

### EC2 역할 & 정책 ###
### EC2 정책 ###
data "aws_iam_policy_document" "ec2_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
### EC2 역할 ###
resource "aws_iam_role" "ec2-role" {
  name = "ecr-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_role.json
### Policy 
}
resource "aws_iam_role_policy_attachment" "AdministratorAccess" {
 role = aws_iam_role.ec2-role.name
 policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
resource "aws_iam_instance_profile" "test_profile" {
 name = "test_profile"
 role = aws_iam_role.ec2-role.name
}
### bastion-Instance 생성 ###
resource "aws_instance" "bastion-host" {
  ami = "ami-011ab7c70f5b5170a"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  vpc_security_group_ids = [aws_security_group.SG_instance.id]
  subnet_id = var.pub-sub1-id
  user_data = <<-EOF
  #!/bin/bash
  sudo -i sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
  sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
  systemctl restart sshd
  echo 'qwe123' | passwd --stdin root
  yum install -y docker

  EOF

  root_block_device {
    volume_size = 10
  }

  tags = var.ec2-tags
}

