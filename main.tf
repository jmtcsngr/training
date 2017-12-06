#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-fcc4db98
#
# Your subnet ID is:
#
#     subnet-092c0d72
#
# Your security group ID is:
#
#     sg-a2c975ca
#
# Your Identity is:
#
#     terraform-training-sheep
#

terraform {
  backend "atlas" {
    name = "jmtcsngr/training"
  }
}

variable "num_webs" {
  default = "3"
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "eu-west-2"
}

provider "aws" "web" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami           = "ami-fcc4db98"
  instance_type = "t2.micro"
  subnet_id     = "subnet-092c0d72"
  count         = "${var.num_webs}"

  vpc_security_group_ids = [
    "sg-a2c975ca",
  ]

  tags = {
    Identity        = "terraform-training-sheep"
    env             = "dev"
    day_of_the_week = "Wednesday"
    Name            = "web ${count.index + 1}/${var.num_webs}"
  }
}

output "public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}
