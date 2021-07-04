<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.9 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_example"></a> [example](#module\_example) | ../.. |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_builds"></a> [bucket\_builds](#input\_bucket\_builds) | Lambda Builds Bucket | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Bucket to save the backups | `string` | n/a | yes |
| <a name="input_lambda_s3_key"></a> [lambda\_s3\_key](#input\_lambda\_s3\_key) | Lambda Build Key | `string` | n/a | yes |
| <a name="input_tf_token"></a> [tf\_token](#input\_tf\_token) | Terraform Cloud Token | `string` | n/a | yes |
| <a name="input_workspaces_ids"></a> [workspaces\_ids](#input\_workspaces\_ids) | List of the workspaces IDs to back up. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apigw_invoke_url"></a> [apigw\_invoke\_url](#output\_apigw\_invoke\_url) | n/a |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | n/a |
<!-- END_TF_DOCS -->