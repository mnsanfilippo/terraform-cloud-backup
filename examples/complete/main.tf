module "example" {
  source = "../.."

  bucket_builds  = var.bucket_builds
  bucket_name    = var.bucket_name
  lambda_s3_key  = var.lambda_s3_key
  tf_token       = var.tf_token
  workspaces_ids = var.workspaces_ids
}