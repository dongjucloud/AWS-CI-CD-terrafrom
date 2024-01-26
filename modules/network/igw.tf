### Internet gateway 생성 ###
resource "aws_internet_gateway" "my_igw" {
  vpc_id = var.vpc-id
  tags = var.igw-tags
}