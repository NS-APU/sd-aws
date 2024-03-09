resource "aws_s3_bucket" "babacafe" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "babacafe" {
  bucket = aws_s3_bucket.babacafe.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
