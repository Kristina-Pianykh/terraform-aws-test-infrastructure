resource "aws_s3_bucket" "test_versioned_bucket" {
  bucket = var.test_versioned_bucket_name
}

resource "aws_s3_bucket_versioning" "test_versioning" {
  bucket = aws_s3_bucket.test_versioned_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "private_test_versioned_bucket" {
  bucket = aws_s3_bucket.test_versioned_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "expire_object_immediately" {
  bucket = aws_s3_bucket.test_versioned_bucket.id

  rule {
    id      = "expire_object_immediately"
    enabled = true

    expiration {
      expired_object_delete_marker = true
    }
  }

}
