variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "subnet_a_cidr" {
  type    = string
  default = "10.10.1.0/24"
}

variable "subnet_b_cidr" {
  type    = string
  default = "10.10.2.0/24"
}

variable "az_a" {
  type    = string
  default = "eu-west-1a"
}

variable "az_b" {
  type    = string
  default = "eu-west-1b"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name."
  type        = string
}

variable "tags" {
  type = map(string)
  default = {
    Project = "LinkBetweenNodes-Episode2"
  }
}
