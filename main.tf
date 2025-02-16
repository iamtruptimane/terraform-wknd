provider "aws" {
    region = var.region
}
resource "aws_instance" "us-east-server" {
  #this is how you can refer resources
  ami = "ami-053a45fff0a704a47"
  instance_type = var.instance_type
  key_name = var.key_name
  availability_zone = "us-east-1b"
  tags = {
    Name = "us-east-server"
  }
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


