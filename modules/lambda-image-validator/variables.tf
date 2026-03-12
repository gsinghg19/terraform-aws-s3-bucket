variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "handler" {
  description = "Lambda handler (file.export)"
  type        = string
  default     = "handler.handler"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "nodejs18.x"
}

variable "timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda memory in MB"
  type        = number
  default     = 256
}

variable "source_dir" {
  description = "Path to the directory containing compiled Lambda code to be zipped"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket the Lambda can access (leave empty to skip S3 trigger)"
  type        = string
  default     = ""
}

variable "s3_bucket_id" {
  description = "ID/name of the S3 bucket for event notification (required if s3_bucket_arn is set)"
  type        = string
  default     = ""
}

variable "output_s3_bucket_arn" {
  description = "ARN of the S3 bucket where converted images are uploaded"
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}
