resource "aws_dynamodb_table" "ip_spectre" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ip"

  attribute {
    name = "ip"
    type = "S"
  }

  tags = {
    Project = "IP-SPECTRE"
    Owner   = "Architect-of-the-Net"
  }
}
