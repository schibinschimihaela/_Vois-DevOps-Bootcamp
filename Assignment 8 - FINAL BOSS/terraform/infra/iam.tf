resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_iam_policy" "ip_spectre_dynamodb" {
  name = "${var.project_name}-dynamodb-policy-${random_id.suffix.hex}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:DeleteItem",
        "dynamodb:DescribeTable"
      ]
      Resource = aws_dynamodb_table.ip_spectre.arn
    }]
  })
}
