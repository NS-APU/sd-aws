resource "aws_s3_bucket" "frontend" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

// resource "aws_s3_bucket_acl" "frontend" {
//   bucket = aws_s3_bucket.frontend.id
//   acl = "public-read"
// 
//   depends_on = [aws_s3_bucket.frontend]
// }

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "babacafe" {
  bucket = aws_s3_bucket.frontend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "frontend" {
  for_each = fileset("dist/", "*")

  bucket = aws_s3_bucket.frontend.id
  key = each.key
  source = each.value.source_path
  content_type = each.value.content_type
}

// resource "aws_s3_bucket_policy" "frontend" {
//   bucket = aws_s3_bucket.frontend.id
//   policy = data.aws_iam_policy_document.frontend.json
// }

// data "aws_iam_policy_document" "frontend" {
//   statement {
//     principals {
//       type        = "AWS"
//       identifiers = [aws_s3_bucket.frontend.id]
//     }
// 
//     actions = [
//       "s3:GetObject",
//       "s3:ListBucket",
//     ]
// 
//     resources = [
//       aws_s3_bucket.frontend.arn,
//       "${aws_s3_bucket.frontend.arn}/*",
//     ]
//   }
// }
