output "backend_config_hint" {
  value = {
    bucket         = aws_s3_bucket.tfstate.id
    dynamodb_table = aws_dynamodb_table.tf_locks.name
    region         = var.aws_region
  }
}
