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


module "image_validator" {
  source = "./modules/lambda-image-validator"

  function_name = "image-validator"
  source_dir    = "${path.root}/lambda/image-validator/src"

  s3_bucket_arn = module.website_s3_bucket.arn
  s3_bucket_id  = module.website_s3_bucket.name

  environment_variables = {
    NODE_ENV = "production"
  }
}

