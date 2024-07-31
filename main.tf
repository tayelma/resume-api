variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

provider "aws" {
  region = var.region
}

resource "aws_dynamodb_table" "resume_table" {
  name         = "ResumeTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "resume_item" {
  table_name = aws_dynamodb_table.resume_table.name
  hash_key   = "user_id"
  item       = file("${path.module}/awsresume.json")
}

resource "aws_s3_bucket" "resume_bucket" {
  bucket = "resume-api-lambda"
}

resource "aws_s3_object" "resume_object" {
  bucket = aws_s3_bucket.resume_bucket.bucket
  key    = "resume-api-lambda"
  source = "${path.module}/resume-lambda-code.zip"
  etag   = filemd5("${path.module}/resume-lambda-code.zip")
}

resource "aws_lambda_function" "resume_api_function" {
  s3_bucket     = aws_s3_bucket.resume_bucket.bucket
  s3_key        = aws_s3_object.resume_object.key
  function_name = "resume_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "resume-lambda-code.lambda_handler"
  runtime       = "python3.12"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "lambda_policy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_apigatewayv2_api" "this" {
  name          = "resume-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "dev"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "this" {
  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"

  integration_uri = aws_lambda_function.resume_api_function.invoke_arn
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "GET /resume"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.resume_api_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

output "apigateway_endpoint" {
  value = aws_apigatewayv2_stage.this.invoke_url
}
