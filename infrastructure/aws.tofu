
locals {
  frontend_buckets = {
    site = "${local.site_name}.co"
    www  = "www.${local.site_name}.co"
  }

  # Cloudflare IP ranges (allow S3 access only via Cloudflare proxy)
  # https://www.cloudflare.com/ips/
  cloudflare_source_ips = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22",
    "2400:cb00::/32",
    "2606:4700::/32",
    "2803:f800::/32",
    "2405:b500::/32",
    "2405:8100::/32",
    "2a06:98c0::/29",
    "2c0f:f248::/32"
  ]
}

resource "aws_s3_bucket" "frontend" {
  for_each = local.frontend_buckets
  bucket   = each.value
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  for_each = local.frontend_buckets
  bucket   = aws_s3_bucket.frontend[each.key].id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  for_each = local.frontend_buckets
  bucket   = aws_s3_bucket.frontend[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.frontend[each.key].arn,
          "${aws_s3_bucket.frontend[each.key].arn}/*"
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = local.cloudflare_source_ips
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  for_each = local.frontend_buckets
  bucket   = aws_s3_bucket.frontend[each.key].id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}
