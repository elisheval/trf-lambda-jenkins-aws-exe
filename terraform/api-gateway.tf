resource "aws_apigatewayv2_api" "lambda_api_gw" {
  name          = "lambdAapiGw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id = aws_apigatewayv2_api.lambda_api_gw.id
  name        = "$default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.main_api_gw.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_cloudwatch_log_group" "main_api_gw" {
  name = "/aws/api-gw-2/${aws_apigatewayv2_api.lambda_api_gw.name}"
  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "lambda_app" {
  api_id = aws_apigatewayv2_api.lambda_api_gw.id
  integration_uri    = aws_lambda_function.hello_lambda_func.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_hello" {
  api_id = aws_apigatewayv2_api.lambda_api_gw.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_app.id}"
}

resource "aws_apigatewayv2_route" "post_hello" {
  api_id = aws_apigatewayv2_api.lambda_api_gw.id
  route_key = "POST /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_app.id}"
}

resource "aws_lambda_permission" "api_gw_perm" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_lambda_func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.lambda_api_gw.execution_arn}/*/*"
}
