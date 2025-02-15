provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "web-server" {
  ami = "ami-053a45fff0a704a47"
  instance_type = "t2.micro"
  key_name = "server-key"
  availability_zone = "us-east-1b"
  tags = {
    Name = "web-server"
  }
}
