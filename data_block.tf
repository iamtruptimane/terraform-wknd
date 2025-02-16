provider "aws" {
    region = var.region
}
data "aws_security_group" "aws-sg" {
  filter {
    name = "vpc-id"
    values = [ "vpc-0cbbdb15bbcd7d653" ]
  }
  filter {
    name = "group-name"
    values = [ "web-sg" ]
  }
}
resource "aws_instance" "web-server" {
  #this is how you can refer resources
  ami = "ami-053a45fff0a704a47"
  instance_type = var.instance_type
  key_name = var.key_name
  availability_zone = "us-east-1b"
  tags = {
    Name = "web-server"
  }
  vpc_security_group_ids = [data.aws_security_group.aws-sg.id]
  #vpc_security_group_ids = ["sg-0ef0726f3c7819b49", "sg-09a34692654e6f350"]

}
variable "region" {
    description = "please enter region"
    type = string
    default = "us-east-1"
}
variable "instance_type" {
    description = " please enter instnace type"
    default = "t2.micro"
}
variable "key_name" {
    default = "server-key"
}
output "demo" {
    value = "hello world"
}
output "instnace_id" {
  value = aws_instance.us-east-server.id
}

