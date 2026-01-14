output "dynamodb_table_name" {
  value = aws_dynamodb_table.ip_spectre.name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.ip_spectre.repository_url
}
