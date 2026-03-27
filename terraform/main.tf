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

# The Domain Name
variable "domain_name" {
  default = "hevar.cloud"
}

# 1. The S3 Bucket
resource "aws_s3_bucket" "portfolio" {
  bucket = "hevar-webpro-2026-1774048638"

  tags = {
    Name        = "Hevar Portfolio"
    Environment = "Production"
    Project     = "Cloud-DevOps-Lab"
    ManagedBy   = "Terraform-Tifa"
  }
}

# Static Website Hosting Configuration (Not strictly needed with CloudFront OAC, but keeping for compatibility)
resource "aws_s3_bucket_website_configuration" "portfolio_hosting" {
  bucket = aws_s3_bucket.portfolio.id
  index_document {
    suffix = "index.html"
  }
}

# SECURE: Block all public access to the bucket! 🛡️🔐
resource "aws_s3_bucket_public_access_block" "portfolio_access" {
  bucket = aws_s3_bucket.portfolio.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# SECURE: Policy allowing ONLY CloudFront to read from S3 via OAC 🛡️
resource "aws_s3_bucket_policy" "allow_cloudfront_oac" {
  bucket = aws_s3_bucket.portfolio.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.portfolio.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

# 2. DynamoDB Table
resource "aws_dynamodb_table" "hevar_lab_table" {
  name           = "HevarLabData"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }

  tags = {
    Name        = "Hevar Lab DynamoDB"
    ManagedBy   = "Terraform-Tifa"
  }
}

# 3. Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# 4. CloudFront Origin Access Control (OAC) 🛡️✨
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "HevarPortfolioOAC"
  description                       = "OAC for S3 Portfolio"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# 5. CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.portfolio.bucket_regional_domain_name
    origin_id                = "S3-Portfolio"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [var.domain_name]

  web_acl_id = "arn:aws:wafv2:us-east-1:443112456918:global/webacl/CreatedByCloudFront-e5aa1485/896a1bf9-bfc0-420f-8058-71326e22985f"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Portfolio"
    cache_policy_id  = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:443112456918:certificate/15a71d5e-9f5f-4d97-bf07-1f3af73c3fa1"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    ManagedBy = "Terraform-Tifa"
  }
}

# 6. Route 53 A Record
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# Outputs
output "cloudfront_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "custom_domain_url" {
  value = "https://${var.domain_name}"
}
