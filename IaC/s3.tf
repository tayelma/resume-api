resource "aws_s3_bucket" "resume_bucket" {
  bucket = "resume-api-lambda"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../api"
  output_path = "${path.module}/resume-lambda-code.zip"
}

resource "aws_s3_object" "resume_object" {
  bucket = aws_s3_bucket.resume_bucket.bucket
  key    = "resume-lambda-code.zip"
  source = data.archive_file.lambda_zip.output_path
  etag   = filemd5(data.archive_file.lambda_zip.output_path)
}
