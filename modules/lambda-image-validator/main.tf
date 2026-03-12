# --- IAM Role for Lambda ---
resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}-exec-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# S3 read/write policy so the Lambda can process images in the bucket
resource "aws_iam_role_policy" "lambda_s3" {
  name = "${var.function_name}-s3-access"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject"
      ]
      Resource = "${var.s3_bucket_arn}/*"
    }]
  })
}

# Write to output bucket
resource "aws_iam_role_policy" "lambda_s3_output" {
  name = "${var.function_name}-s3-output-access"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject"]
      Resource = "${var.output_s3_bucket_arn}/*"
    }]
  })
}

# --- Package Lambda code ---
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/dist/function.zip"
}

# --- Lambda function ---
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_exec.arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = var.environment_variables
  }
}
