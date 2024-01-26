### Subnet 생성 ###
### Public Subnet 생성 ###
resource "aws_subnet" "pub_sub1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.pub-sub1-cidr
  map_public_ip_on_launch = true
  availability_zone = var.zone_1
  tags = var.pub-sub1-tags
}
resource "aws_subnet" "pub_sub2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.pub-sub2-cidr
  map_public_ip_on_launch = true
  availability_zone = var.zone_2
  tags = var.pub-sub2-tags
}

### Public-Route 생성-연결 ###
resource "aws_route_table" "pub_rt" {
  vpc_id = var.vpc-id
  tags = var.pub-rt-tags
}
resource "aws_route" "pub_route" {
  route_table_id = var.pub-rt-id
  destination_cidr_block = var.destination_cidr_block
  gateway_id = var.myigw-id
}
resource "aws_route_table_association" "pub_assoc1" {
  subnet_id = var.pub-sub1-id
  route_table_id = var.pub-rt-id
}
resource "aws_route_table_association" "pub_assoc2" {
  subnet_id = var.pub-sub2-id
  route_table_id = var.pub-rt-id
}

### Private-Route 생성 1,2 ###
### Private-Subnet 생성 ###
resource "aws_subnet" "pri_sub1" {
  vpc_id = var.vpc-id
  cidr_block = var.pri-sub1-cidr
  availability_zone = var.zone_1
  tags = var.pri-sub1-tags
}
resource "aws_subnet" "pri_sub2" {
  vpc_id = var.vpc-id
  cidr_block = var.pri-sub2-cidr
  availability_zone = var.zone_2
  tags = var.pri-sub2-tags
}

### Private-Route 생성-연결 ###
resource "aws_route_table" "pri_rt" {
  vpc_id = var.vpc-id
  tags = var.pri-rt-tags
}
resource "aws_route" "pri_route" {
  route_table_id = var.pri-rt-id
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id = var.mynat-id
}
resource "aws_route_table_association" "private_assoc1" {
  subnet_id = var.pri-sub1-id
  route_table_id = var.pri-rt-id
}
resource "aws_route_table_association" "private_assoc2" {
  subnet_id = var.pri-sub2-id
  route_table_id = var.pri-rt-id
}

