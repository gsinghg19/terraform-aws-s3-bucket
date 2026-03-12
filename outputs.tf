output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.ec2_instances[*].public_ip
}

output "website_bucket_arn" {
  description = "ARN of the bucket"
  value       = module.website_s3_bucket.arn
}

output "website_bucket_name" {
  description = "Name (id) of the bucket"
  value       = module.website_s3_bucket.name
}

output "website_bucket_domain" {
  description = "Domain name of the bucket"
  value       = module.website_s3_bucket.domain
}

output "image_bucket_arn" {
  description = "ARN of the image bucket"
  value       = module.image_s3_bucket.arn
}

output "image_bucket_name" {
  description = "Name (id) of the image bucket"
  value       = module.image_s3_bucket.name
}

output "pdf_bucket_arn" {
  description = "ARN of the PDF bucket"
  value       = module.pdf_s3_bucket.arn
}

output "pdf_bucket_name" {
  description = "Name (id) of the PDF bucket"
  value       = module.pdf_s3_bucket.name
}

output "lambda_function_name" {
  description = "Name of the image validator Lambda"
  value       = module.image_validator.function_name
}

output "lambda_function_arn" {
  description = "ARN of the image validator Lambda"
  value       = module.image_validator.function_arn
}
