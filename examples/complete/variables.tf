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

variable "bucket_name" {
  type        = string
  description = "Bucket to save the backups"
}