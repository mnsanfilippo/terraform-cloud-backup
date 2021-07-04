// API GW

module "api_gateway" {
        depends_on             = [aws_lambda_function.tfc-workspaces-backup]
  source                 = "terraform-aws-modules/apigateway-v2/aws"
  name                   = var.apigw_name
  description            = "tfe-backup"
  protocol_type          = "HTTP"
  create_api_domain_name = false

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Routes and integrations
  integrations = {
    "POST /${aws_lambda_function.tfc-workspaces-backup.function_name}" = {
      lambda_arn             = aws_lambda_function.tfc-workspaces-backup.arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }

  tags = {
    Name = "tfc-workspaces-backup"
  }
}

// Lambda


resource "aws_lambda_function" "tfc-workspaces-backup" {
  function_name = var.lambda_name
  s3_bucket     = var.bucket_builds
  s3_key        = var.lambda_s3_key
  handler       = "main"
  runtime       = "go1.x"
  memory_size   = 128
  timeout       = 10
  role          = aws_iam_role.tfc-workspaces-backup.arn

  environment {
    variables = {
      TF_TOKEN = var.tf_token
      BUCKET   = var.bucket_name
    }
  }
}

resource "aws_iam_role" "tfc-workspaces-backup" {
  name                = "role-lambda-tfc-backup"
  assume_role_policy  = data.aws_iam_policy_document.aws_lambda_trust_policy.json
  managed_policy_arns = [aws_iam_policy.tfc-backup-lambda-policy.arn]
}

resource "aws_iam_policy" "tfc-backup-lambda-policy" {
  policy = data.template_file.tfe-backup-lambda-policy.rendered
}

resource "aws_kms_key" "tfc-workspace-backup" {
  description             = "tfc-workspace-backup"
  deletion_window_in_days = 10
}

resource "aws_lambda_permission" "apigw_lambda" {
  depends_on    = [module.api_gateway.apigatewayv2_api_execution_arn]
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tfc-workspaces-backup.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = join("", [module.api_gateway.apigatewayv2_api_execution_arn, "/*/*/", aws_lambda_function.tfc-workspaces-backup.function_name])
}


// S3

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.2.0"
  bucket  = var.bucket_name
  acl     = "private"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning = {
    enabled = true
  }
  object_lock_configuration = {
    object_lock_enabled = "Enabled"
  }
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


// Workspaces

resource "tfe_notification_configuration" "tfc-workspaces-backup" {
  depends_on       = [time_sleep.wait_120_seconds]
  for_each         = toset(var.workspaces_ids)
  name             = var.notification_name
  enabled          = true
  destination_type = "generic"
  triggers         = ["run:completed", "run:errored"]
  url              = join("", [local.apigw_invoke_url, aws_lambda_function.tfc-workspaces-backup.function_name])
  workspace_id     = each.value
}


// There is a delay between the API GW is deployed and the availability of this endpoint, without this delay,
// the tfe_notification_configuration is going to fail at the moment of check the endpoint
resource "time_sleep" "wait_120_seconds" {
  depends_on      = [aws_lambda_permission.apigw_lambda, module.api_gateway, data.aws_lambda_function.tfc-backup]
  create_duration = "150s"
}