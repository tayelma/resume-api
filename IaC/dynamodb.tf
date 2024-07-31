resource "aws_dynamodb_table" "resume_table" {
  name         = "ResumeTable-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Project     = "resume-api"
  }
}

resource "aws_dynamodb_table_item" "resume_item" {
  table_name = aws_dynamodb_table.resume_table.name
  hash_key   = "user_id"
  item       = file("${path.module}/awsresume.json")
}
