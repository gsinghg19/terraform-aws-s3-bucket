output "helper_bucket_name" {
  description = "Echoes the bucket name used by the helper for assertions"
  value       = var.bucket_name
}

output "helper_tags" {
  description = "Final tags that should be sent to the website module"
  value       = local.merged_tags
}

output "website_bucket_name" {
  description = "Website module bucket name output"
  value       = module.website.name
}

output "website_bucket_arn" {
  description = "Website module ARN output"
  value       = module.website.arn
}

output "website_bucket_domain" {
  description = "Website module domain output"
  value       = module.website.domain
}
