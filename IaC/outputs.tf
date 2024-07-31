output "apigateway_endpoint" {
  description = "The endpoint of the API Gateway"
  value       = aws_apigatewayv2_stage.dev.invoke_url
}
