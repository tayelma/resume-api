resource "aws_lambda_function" "resume_api_function" {
  s3_bucket     = aws_s3_bucket.resume_bucket.bucket
  s3_key        = "resume-lambda-code.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "resume-lambda-code.lambda_handler"
  runtime       = "python3.9"

  tags = {
    Environment = var.environment
    Project     = "resume-api"
  }
}
