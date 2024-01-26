### Elastic Ip 생성 ###
resource "aws_eip" "NAT-eip" {
  domain = "vpc"
}
### NAT gateway 생성 ###
resource "aws_nat_gateway" "myNAT" {
  allocation_id = var.myeip-id
  subnet_id = var.pub-sub2-id
  tags = var.nat-tags
}