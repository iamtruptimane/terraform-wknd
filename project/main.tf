# define terraform backend block
terraform {
  backend "s3" {
    bucket = "terraform-backend-s3-t23-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}
# define provider block
provider "aws" {
  region = var.region
}
#define resource block
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project}-vpc"
  }
}
#define private subnet
resource "aws_subnet" "private_sub" {
  #blocktype.resource_type.resource_name.attribute
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.pri_sub_cidr
  availability_zone = var.az1
  tags = {
    Name = "${var.project}-private-subnet"
  }
}
#define public subnet
resource "aws_subnet" "public_sub" {
  #blocktype.resource_type.resource_name.attribute
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.pub_sub_cidr
  availability_zone = var.az2
  tags = {
    Name = "${var.project}-public-subnet"
  }
  map_public_ip_on_launch = true
}
#define internet gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.project}-IGW"
  }
}
#use exsisting rout table
resource "aws_default_route_table" "main-RT" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id
  tags = {
    Name = "${var.project}-RT"
  }
}
#define routes inside the default RT
resource "aws_route" "default_route" {
  route_table_id = aws_vpc.my_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id
}
#define security group
resource "aws_security_group" "sg1" {
  vpc_id = aws_vpc.my_vpc.id
  name = "${var.project}-sg1"
  description = "allow http, https, ssh traffic"
  ingress {
    protocol = "tcp"
    from_port = "80"
    to_port = "80"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = "443"
    to_port = "443"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  #to define dependency of sg on vpc
  depends_on = [ aws_vpc.my_vpc ]

}
#define public instance
resource "aws_instance" "server1" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key
  subnet_id = aws_subnet.public_sub.id
  availability_zone = var.az2
  vpc_security_group_ids = [aws_vpc.my_vpc.default_security_group_id, aws_security_group.sg1.id]
  tags = {
    Name = "${var.project}-public-server"
  }
  depends_on = [ aws_security_group.sg1 ]
}
#define private instance
resource "aws_instance" "server2" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key
  subnet_id = aws_subnet.public_sub.id
  availability_zone = var.az1
  vpc_security_group_ids = [aws_vpc.my_vpc.default_security_group_id, aws_security_group.sg1.id]
  tags = {
    Name = "${var.project}-private-server"
  }
  depends_on = [ aws_security_group.sg1 ]
}

