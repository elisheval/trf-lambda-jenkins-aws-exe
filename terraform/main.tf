provider "aws" {
  access_key = var.accessKey
  secret_key = var.secretKey
  region     = var.region
}

output "api_gateway_url" {
  value = aws_apigatewayv2_stage.dev.invoke_url
}