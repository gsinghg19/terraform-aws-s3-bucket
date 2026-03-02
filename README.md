# terraform-aws-s3-bucket
Terraform Module Tutorial: AWS S3 Static Website

This project walks you through creating a reusable Terraform module that provisions an AWS S3 bucket configured to host a static website.

By the end, you will:

Create a custom Terraform module

Provision a public S3 static website bucket

Upload website files

Access the website in a browser

Clean up all resources safely

Prerequisites

Before starting, make sure you have:

An AWS account

AWS credentials configured (via AWS CLI default profile)

AWS CLI installed

Terraform CLI installed

Verify installations:

aws --version
terraform --version
Project Structure

After setup, your project should look like this:

.
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   └── aws-s3-static-website-bucket/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── README.md
│       ├── LICENSE
│       └── www/
│           ├── index.html
│           └── error.html
Step 1: Initialize Your Project

If starting fresh:

mkdir terraform-s3-website
cd terraform-s3-website

Initialize Terraform:

terraform init
Step 2: Create the Module Directory

Create your module folder:

mkdir -p modules/aws-s3-static-website-bucket/www
Step 3: Create Module Files

Inside:

modules/aws-s3-static-website-bucket/

Create the following files:

main.tf

variables.tf

outputs.tf

README.md

LICENSE

Step 4: Add Module Code
modules/aws-s3-static-website-bucket/main.tf
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_website_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource = [
        aws_s3_bucket.s3_bucket.arn,
        "${aws_s3_bucket.s3_bucket.arn}/*"
      ]
    }]
  })
}
modules/aws-s3-static-website-bucket/variables.tf
variable "bucket_name" {
  description = "Name of the S3 bucket. Must be globally unique."
  type        = string
}

variable "tags" {
  description = "Tags for the bucket."
  type        = map(string)
  default     = {}
}
modules/aws-s3-static-website-bucket/outputs.tf
output "arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.s3_bucket.arn
}

output "name" {
  description = "Name of the bucket"
  value       = aws_s3_bucket.s3_bucket.id
}

output "domain" {
  description = "Website domain"
  value       = aws_s3_bucket_website_configuration.s3_bucket.website_domain
}
Step 5: Create Sample Website Files

Inside:

modules/aws-s3-static-website-bucket/www/

Create:

index.html
<!DOCTYPE html>
<html>
<head>
  <title>My Static Website</title>
</head>
<body>
  <h1>Hello from Terraform!</h1>
</body>
</html>
error.html
<!DOCTYPE html>
<html>
<body>
  <h1>Error - Page Not Found</h1>
</body>
</html>
Step 6: Configure the Root Module

Create or edit main.tf in the root directory:

provider "aws" {
  region = "us-west-2"
}

module "website_s3_bucket" {
  source = "./modules/aws-s3-static-website-bucket"

  bucket_name = "your-unique-bucket-name-12345"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

⚠️ Replace your-unique-bucket-name-12345 with a globally unique name.

Step 7: Add Root Outputs

Create or edit outputs.tf in the root:

output "website_bucket_name" {
  value = module.website_s3_bucket.name
}

output "website_bucket_domain" {
  value = module.website_s3_bucket.domain
}
Step 8: Install and Apply

Initialize:

terraform init

Preview:

terraform plan

Apply:

terraform apply

Type:

yes

When complete, get your website domain:

terraform output website_bucket_domain
Step 9: Upload Website Files

Upload your HTML files:

aws s3 cp modules/aws-s3-static-website-bucket/www/ \
  s3://$(terraform output -raw website_bucket_name)/ \
  --recursive
Step 10: Visit Your Website

Open in browser:

http://<YOUR_BUCKET_NAME>.s3-website-us-west-2.amazonaws.com

You should see:

Hello from Terraform!
Step 11: Clean Up

Remove uploaded files:

aws s3 rm s3://$(terraform output -raw website_bucket_name)/ --recursive

Destroy infrastructure:

terraform destroy

Type:

yes

All resources will be deleted.

What You Learned

How to structure a Terraform module

How modules use variables and outputs

How to reference a local module

How to host a static website on S3

How to safely destroy infrastructure
