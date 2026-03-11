variable "aws_region" {
  description = "AWS region for test helper provider"
  type        = string
  default     = "us-west-2"
}

variable "aws_access_key_id" {
  description = "Optional AWS access key ID for tests"
  type        = string
  sensitive   = true
  default     = ""
}

variable "aws_secret_access_key" {
  description = "Optional AWS secret access key for tests"
  type        = string
  sensitive   = true
  default     = ""
}

variable "bucket_name" {
  description = "Bucket name used by the S3 static website module during tests"
  type        = string
}

variable "tags" {
  description = "Tags passed to the S3 static website module"
  type        = map(string)
  default     = {}
}
