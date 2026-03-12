variable "bucket_name" {
  description = "Name of the s3 bucket for storing PDF documents."
  type        = string
}

variable "tags" {
  description = "Tags to set on the s3 pdf bucket."
  type        = map(string)
  default     = {}
}
