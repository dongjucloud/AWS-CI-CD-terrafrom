output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.my_vpc.id
}
output "pub_sub1_id" {
  description = "PUBLIC SUBNET1"
  value = aws_subnet.pub_sub1.id
}
output "pub_sub2_id" {
  description = "PUBLIC SUBNET2"
  value = aws_subnet.pub_sub2.id
}
output "pri_sub1_id" {
  description = "PRIVATE SUBNET1"
  value = aws_subnet.pri_sub1.id
}
output "pri_sub2_id" {
  description = "PRIVATE SUBNET2"
  value = aws_subnet.pri_sub2.id
}
output "pub_rt_id" {
 description = "ROUTING TABLE ID"
 value = aws_route_table.pub_rt.id
}
output "pri_rt_id" {
 description = "ROUTING TABLE ID"
 value = aws_route_table.pri_rt.id
}
output "eip_id" {
 description = "VALUE"
 value = aws_eip.NAT-eip.id
}
output "igw_id" {
 description = "IGW ID"
 value = aws_internet_gateway.my_igw.id
}
output "nat_id" {
 description = "VALUE"
 value = aws_nat_gateway.myNAT.id
}
