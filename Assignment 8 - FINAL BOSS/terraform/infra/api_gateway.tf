# resource "aws_apigatewayv2_api" "this" {
#   name          = "${var.project_name}-api"
#   protocol_type = "HTTP"

#   cors_configuration {
#     allow_origins = ["*"]
#     allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
#     allow_headers = ["*"]
#   }
# }

# resource "aws_apigatewayv2_integration" "backend" {
#   api_id           = aws_apigatewayv2_api.this.id
#   integration_type = "HTTP_PROXY"
#   integration_uri  = "http://${aws_instance.this.public_ip}:8080/{proxy}"
#   integration_method = "ANY"
# }

# resource "aws_apigatewayv2_route" "default" {
#   api_id    = aws_apigatewayv2_api.this.id
#   route_key = "ANY /{proxy+}"
#   target    = "integrations/${aws_apigatewayv2_integration.backend.id}"
# }

output "api_gateway_url" {
  value       = aws_apigatewayv2_api.this.api_endpoint
  description = "API Gateway URL"
}