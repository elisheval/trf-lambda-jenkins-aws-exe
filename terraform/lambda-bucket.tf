
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.bucketName
}

data "archive_file" "lambda_app_zip" {
  type = var.zipFile
  source_file = var.sourceFile
  output_path = var.outputPath
}

resource "aws_s3_object" "lambda_app_object" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = var.codeObjectkey
  source = data.archive_file.lambda_app_zip.output_path
}
