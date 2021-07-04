package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os"
	"strings"
	"testing"
)

var terraformPlan = true
var project = "tfc-workspaces-backup"
var awsRegion = "us-east-1"
var event_applied = "event_applied.json"
var event_errored = "event_errored.json"
var event_not_modified = "event_not_modified.json"
var workspaces_ids = []string{"ws-WzbRhM4ojZXjRvoP"}
var tf_token = os.Getenv("TF_TOKEN")
var bucket_builds = os.Getenv("BUCKET_BUILDS")
var lambda_s3_key = os.Getenv("LAMBDA_S3_KEY")

func TestIntegration(t *testing.T) {
	// This is an integration test since the creation of the last resource ( the tfc notification ), tests
	// the response of the lambda through the API GW execution.
	// Also, I am going to check that the S3 Bucket has the versioning enabled
	t.Parallel()

	terraformOpts := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"bucket_name":       fmt.Sprintf("%s-%v", project, strings.ToLower(random.UniqueId())),
			"apigw_name":        fmt.Sprintf("%s-%v", project, strings.ToLower(random.UniqueId())),
			"lambda_name":       fmt.Sprintf("%s-%v", project, strings.ToLower(random.UniqueId())),
			"notification_name": fmt.Sprintf("%s-%v", project, strings.ToLower(random.UniqueId())),
			"workspaces_ids":    workspaces_ids,
			"tf_token":          tf_token,
			"bucket_builds":     bucket_builds,
			"lambda_s3_key":     lambda_s3_key,
		},
	})

	// We want to destroy the infrastructure after testing.
	defer terraform.Destroy(t, terraformOpts)

	// Deploy the infrastructure with the options defined above
	terraform.InitAndApply(t, terraformOpts)

	// Get the bucket ID so we can query AWS
	bucketID := terraform.Output(t, terraformOpts, "bucket_id")

	// Get the versioning status to test that versioning is enabled
	versioningEnabled := aws.GetS3BucketVersioning(t, awsRegion, bucketID)

	// Test that the status we get back from AWS is "Enabled" for versioning
	assert.Equal(t, "Enabled", versioningEnabled)

}
