provider "aws" {
  region     = "us-west-2"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  count = 2
  name  = "my-ec2-cluster-${count.index}"

  ami                    = "ami-0c5204531f799e0c6"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "website_s3_bucket" {
  source = "./modules/aws-s3-bucket-static-websites"

  bucket_name = "guppy-example-feb-2026"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "image_s3_bucket" {
  source      = "./modules/aws-s3-bucket-image-storage"
  bucket_name = "guppy-converted-images-feb-2026"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "pdf_s3_bucket" {
  source      = "./modules/aws-s3-bucket-pdf-doc-storage"
  bucket_name = "guppy-pdf-docs-feb-2026"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "image_validator" {
  source = "./modules/lambda-image-validator"

  function_name = "image-validator"
  source_dir    = "${path.root}/lambda/image-validator/src"

  s3_bucket_arn = module.image_s3_bucket.arn
  s3_bucket_id  = module.image_s3_bucket.name

  output_s3_bucket_arn = module.image_s3_bucket.arn

  environment_variables = {
    NODE_ENV             = "production"
    OUTPUT_S3_BUCKET_ARN = module.image_s3_bucket.name
  }
}

