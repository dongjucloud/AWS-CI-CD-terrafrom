##### VPC 생성 #####
variable "vpc_cidr" {
description = "VPC"
  type = string
  default = "10.16.0.0/16"
}
variable "instance_tenancy" {
  description = "Instance Tenancy"
  type = string
  default = "default"
}
variable "vpc_tag" {
  description = "VPC tags"
  type = map(string)
  default = {
  Name = "my_vpc"
  }
}
variable "vpc-id" {
  description = "VPC ID"
  type = string
}
### Subnet ###
### public subnet ###
variable "pub-sub1-cidr" {
  description = "Pub_Sub1 CIDR Block"
  type = string
  default = "10.16.1.0/24"
}
variable "pub-sub2-cidr" {
 description = "Pub_Sub2 CIDR Block"
 type = string
 default = "10.16.2.0/24"
}
variable "pub-sub1-tags" {
 description = "Pub_Sub1 tags"
 type = map(string)
 default = { Name = "pub_sub1" }
}
variable "pub-sub2-tags" {
 description = "Pub_Sub2 tags"
 type = map(string)
 default = { Name = "pub_sub2" }
}
### zone ### 
variable "zone_1" {
 description = "value"
 type = string
 default = "us-east-2a"
}
variable "zone_2" {
 description = "value"
 type = string
 default = "us-east-2b"
}
### private-subnet ###
variable "pri-sub1-cidr" {
 description = "Pri_Sub1 CIDR Block"
 type = string
 default = "10.16.3.0/24"
}
variable "pri-sub2-cidr" {
 description = "Pri_Sub2 CIDR Block"
 type = string
 default = "10.16.4.0/24"
}
variable "pri-sub1-tags" {
 description = "Pri_Sub1 tags"
 type = map(string)
 default = { Name = "pri_sub1" }
}
variable "pri-sub2-tags" {
 description = "Pri_Sub2 tags"
 type = map(string)
 default = { Name = "pri_sub2" }
}
### route_table ###
variable "pub-rt-id" {
 description = "Pub_RT_ID"
 type = string
}
variable "pub-rt-tags" {
 description = "Pub_RT tags"
 type = map(string)
 default = { Name = "pub_rt_table" }
}
variable "myigw-id" {
 description = "Internet Gateway ID"
 type = string
}
variable "pub-sub1-id" {
 description = "Pub_Sub1 ID"
 type = string
}
variable "pub-sub2-id" {
 description = "Pub_Sub_2 ID"
 type = string
}
variable "pri-rt-id" {
 description = "Pri_RT ID"
 type = string
}
variable "pri-rt-tags" {
  description = "Pri_RT tags"
  type = map(string)
  default = { Name = "pri_rt_table" }
}
variable "pri-sub1-id" {
 description = "Pri_Sub1 ID"
 type = string
}
variable "pri-sub2-id" {
 description = "Pri_Sub2 ID"
 type = string
}

variable "destination_cidr_block" {
  description = "Destination_cidr_block"
  type = string
  default = "0.0.0.0/0"
}
### internet gateway ###
variable "igw-tags" {
  description = "Internet Gateway tags"
  type = map(string)
  default = { Name = "my_igw" }
}
### NAT gateway ###
variable "myeip-id" {
 description = "Eip ID"
 type = string
}
variable "mynat-id" {
 description = "NAT Gateway ID"
 type = string
}
variable "nat-tags" {
  description = "Internet Gateway tags"
  type = map(string)
  default = { Name = "my_nat" }
}
### bation host ### 
variable "ec2-tags" {
  description = "Internet Gateway tags"
  type = map(string)
  default = { Name = "bastion-host" }
}
