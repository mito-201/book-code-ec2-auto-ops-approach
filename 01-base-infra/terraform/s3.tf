resource "aws_s3_bucket" "ssm" {
  bucket = "${var.name_prefix}-s3-ssm"
}
