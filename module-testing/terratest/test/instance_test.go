package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformSetupInstance(t *testing.T) {
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "./wrapper",
		VarFiles:     []string{"../config/terratest.tfvars"},
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Get single input parameters
	project := terraform.GetVariableAsStringFromVarFile(t, "./config/terratest.tfvars", "project_id")
	zone := terraform.GetVariableAsStringFromVarFile(t, "./config/terratest.tfvars", "zone")

	// Get outputs
	instance_name := terraform.Output(t, terraformOptions, "instance_name")

	err = initGCPClient()
	if err != nil {
		t.Fatalf("error while creating GCP client: %s", err)
	}

	instance, err := getInstance(project, zone, instance_name)
	if err != nil {
		t.Fatalf("error while getting Cloud router: %s", err)
	}

	// Check Cloud router attributes
	assert.Equal(t, instance_name, instance.Name)
}
