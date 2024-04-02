resource "aws_lambda_function" "hello_lambda_func" {
  function_name = var.lambdaFunctionName
  s3_key        = aws_s3_object.lambda_app_object.key
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
  handler = "${var.lambdaFileName}.${var.lambdaFileFunction}"
  runtime = var.awsLambdaRuntime
  role = "${aws_iam_role.app_lambda_exec.arn}"
}

resource "aws_iam_role" "app_lambda_exec" {
  name = var.iamRoleLambda
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}