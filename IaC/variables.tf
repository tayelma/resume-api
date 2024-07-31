variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment to deploy resources in (e.g., dev, prod)"
  default     = "dev"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  default     = "resume_function"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store Lambda code"
  default     = "resume-api-lambda"
}
