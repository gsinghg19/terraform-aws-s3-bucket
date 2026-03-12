output "arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}

output "name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.this.id
}