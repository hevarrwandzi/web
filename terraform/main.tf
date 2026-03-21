# Terraform Configuration for Hevar's Cloud Lab 🏗️🥊

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

# The S3 Bucket for the Portfolio
# This represents the bucket I created manually for you.
resource "aws_s3_bucket" "portfolio" {
  bucket = "hevar-webpro-2026-1774048638"

  tags = {
    Name        = "Hevar Portfolio"
    Environment = "Production"
    Project     = "Cloud-DevOps-Lab"
    ManagedBy   = "Terraform-Tifa"
  }
}

# Static Website Hosting Configuration
resource "aws_s3_bucket_website_configuration" "portfolio_hosting" {
  bucket = aws_s3_bucket.portfolio.id

  index_document {
    suffix = "index.html"
  }
}

# Public Access Block (Disabled for static hosting)
resource "aws_s3_bucket_public_access_block" "portfolio_access" {
  bucket = aws_s3_bucket.portfolio.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket Policy to allow public reads
resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.portfolio.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetter"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.portfolio.arn}/*"
      },
    ]
  })
}

# Output the S3 Website URL
output "website_url" {
  value = aws_s3_bucket_website_configuration.portfolio_hosting.website_endpoint
}
