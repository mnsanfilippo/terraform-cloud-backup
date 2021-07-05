# Terraform Cloud Backup
This module creates the last terraform state in S3 of the given workspaces every time a Terraform state changes.
## Usage
This module needs the lambda build in S3, first you should build this lambda and upload it to S3
[go-tools-tfc-backup](https://github.com/mnsanfilippo/go-tools-tfc-backup)
```terraform
module "example" {
  source = "https://github.com/mnsanfilippo/terraform-cloud-backup.git?ref=main"
  bucket_builds  = var.bucket_builds
  bucket_name    = var.bucket_name
  lambda_s3_key  = var.lambda_s3_key
  tf_token       = var.tf_token
  workspaces_ids = var.workspaces_ids
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.42.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | 0.25.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.42.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.25.3 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | terraform-aws-modules/apigateway-v2/aws |  |
| <a name="module_s3-bucket"></a> [s3-bucket](#module\_s3-bucket) | terraform-aws-modules/s3-bucket/aws | 2.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.tfc-backup-lambda-policy](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.tfc-workspaces-backup](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/iam_role) | resource |
| [aws_kms_key.tfc-workspace-backup](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/kms_key) | resource |
| [aws_lambda_function.tfc-workspaces-backup](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.apigw_lambda](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lambda_permission) | resource |
| [tfe_notification_configuration.tfc-workspaces-backup](https://registry.terraform.io/providers/hashicorp/tfe/0.25.3/docs/resources/notification_configuration) | resource |
| [time_sleep.wait_120_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_iam_policy_document.aws_lambda_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/iam_policy_document) | data source |
| [aws_lambda_function.tfc-backup](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/lambda_function) | data source |
| [aws_s3_bucket_object.build](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/s3_bucket_object) | data source |
| [template_file.tfe-backup-lambda-policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apigw_name"></a> [apigw\_name](#input\_apigw\_name) | n/a | `string` | `"tfc-workspaces-backup"` | no |
| <a name="input_bucket_builds"></a> [bucket\_builds](#input\_bucket\_builds) | Lambda Builds Bucket | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Bucket to save the backups | `string` | n/a | yes |
| <a name="input_lambda_name"></a> [lambda\_name](#input\_lambda\_name) | n/a | `string` | `"tfc-workspaces-backup"` | no |
| <a name="input_lambda_s3_key"></a> [lambda\_s3\_key](#input\_lambda\_s3\_key) | Lambda Build Key | `string` | n/a | yes |
| <a name="input_notification_name"></a> [notification\_name](#input\_notification\_name) | n/a | `string` | `"tfc-workspaces-backup"` | no |
| <a name="input_tf_token"></a> [tf\_token](#input\_tf\_token) | Terraform Cloud Token | `string` | n/a | yes |
| <a name="input_workspaces_ids"></a> [workspaces\_ids](#input\_workspaces\_ids) | List of the workspaces IDs to back up. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apigw_invoke_url"></a> [apigw\_invoke\_url](#output\_apigw\_invoke\_url) | n/a |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | n/a |
<!-- END_TF_DOCS -->
