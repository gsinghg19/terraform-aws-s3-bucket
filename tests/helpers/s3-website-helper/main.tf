terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = var.aws_access_key_id != "" ? var.aws_access_key_id : null
  secret_key                  = var.aws_secret_access_key != "" ? var.aws_secret_access_key : null
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = false
}

locals {
  default_tags = {
    Terraform = "true"
    TestSuite = "terraform-test"
  }

  merged_tags = merge(local.default_tags, var.tags)
}

module "website" {
  source = "../../../modules/aws-s3-bucket-static-websites"

  bucket_name = var.bucket_name
  tags        = local.merged_tags
}
