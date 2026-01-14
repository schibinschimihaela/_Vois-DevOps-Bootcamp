resource "aws_iam_policy" "ip_spectre_dynamodb" {
  name = "ip-spectre-dynamodb-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:DeleteItem"
        ]
        Resource = aws_dynamodb_table.ip_spectre.arn
      }
    ]
  })
}
