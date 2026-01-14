resource "aws_dynamodb_table" "ip_spectre" {
  name         = "ip-spectre-logs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ip"

  attribute {
    name = "ip"
    type = "S"
  }

  tags = {
    Name = "ip-spectre-dynamodb"
  }
}
