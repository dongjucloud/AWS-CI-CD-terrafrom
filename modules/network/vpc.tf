#### VPC 생성 ####
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = var.instance_tenancy
  tags = var.vpc_tag
}
