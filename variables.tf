locals {
  lambda_name      = aws_lambda_function.tfc-workspaces-backup.function_name
  bucket_arn       = module.s3-bucket.s3_bucket_arn
  kms_arn          = aws_kms_key.tfc-workspace-backup.arn
  apigw_invoke_url = module.api_gateway.default_apigatewayv2_stage_invoke_url
}

variable "lambda_name" {
  type    = string
  default = "tfc-workspaces-backup"
}

variable "bucket_name" {
  type        = string
  description = "Bucket to save the backups"
}

variable "apigw_name" {
  type    = string
  default = "tfc-workspaces-backup"
}

variable "notification_name" {
  type    = string
  default = "tfc-workspaces-backup"
}

variable "workspaces_ids" {
  type        = list(string)
  description = "List of the workspaces IDs to back up."
}

variable "tf_token" {
  type        = string
  description = "Terraform Cloud Token"
}

variable "bucket_builds" {
  type        = string
  description = "Lambda Builds Bucket"
}
variable "lambda_s3_key" {
  type        = string
  description = "Lambda Build Key"
}