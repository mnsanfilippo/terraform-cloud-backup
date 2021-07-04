data "aws_lambda_function" "tfc-backup" {
  depends_on    = [aws_lambda_function.tfc-workspaces-backup]
  function_name = local.lambda_name
}

data "aws_s3_bucket_object" "build" {
  bucket = var.bucket_builds
  key    = var.lambda_s3_key
}

data "template_file" "tfe-backup-lambda-policy" {
  template = file("${path.module}/templates/lambda_policy.json.tpl")

  vars = {
    bucket_arn = local.bucket_arn
    kms_arn    = local.kms_arn
  }
}

data "aws_iam_policy_document" "aws_lambda_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
