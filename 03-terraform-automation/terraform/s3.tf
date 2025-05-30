resource "aws_s3_bucket" "codepipeline" {
  bucket = "${var.name_prefix}-s3-codepipeline"
}

resource "aws_s3_bucket" "artifact" {
  bucket = "${var.name_prefix}-s3-artifact"
}

resource "aws_s3_bucket_versioning" "artifact_versioning" {
  bucket = aws_s3_bucket.artifact.id # 上で定義したアーティファクトバケットを参照

  versioning_configuration {
    status = "Enabled" # バージョニングを有効化
  }
}