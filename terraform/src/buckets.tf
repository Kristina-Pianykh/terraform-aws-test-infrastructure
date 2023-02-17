resource "aws_s3_bucket" "tf_backend_s3" {
  bucket = "tf-demo-storage"
}

resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket = aws_s3_bucket.tf_backend_s3.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}

resource "aws_s3_bucket_versioning" "s3_disabled_versioning" {
  bucket = aws_s3_bucket.tf_backend_s3.id
  versioning_configuration {
    status = "Suspended"
  }
}
