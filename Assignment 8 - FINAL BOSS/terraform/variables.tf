variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "ip-spectre"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "ssh_cidr" {
  description = "CIDR allowed to SSH into EC2"
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
}
