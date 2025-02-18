variable "region" {
  default = "us-east-1"
}
variable "az1" {
  default = "us-east-1a"
}
variable "az2" {
  default = "us-east-1b"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "pri_sub_cidr" {
  default = "10.12.0.0/20"
}
variable "pub_sub_cidr" {
  default = "10.10.0.0/20"
}
variable "project" {
  default = "IEC"
}
variable "ami" {
  default = "ami-053a45fff0a704a47"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key" {
  default = "server-key"
}