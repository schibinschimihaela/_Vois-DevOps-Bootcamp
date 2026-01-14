variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "ip_spectre_logs"
}
