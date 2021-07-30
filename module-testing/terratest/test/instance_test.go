package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Tests a basic GCE instance creation
func TestTerraformSetupInstance(t *testing.T) {
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "./wrapper",
		// Define a config file used as source for the input variables
		VarFiles: []string{"../config/terratest.tfvars"},
		// If you do not want to use config files, you can use the "Vars" attribute
		// Vars: map[string]interface{}{
		// 	"project": "abc1234",
		// 	"vm_name": "terratest-vm",
		// 	"zone": "europe-west4-b",
		// 	"...": "...",
		// },
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Get single input parameters
	project := terraform.GetVariableAsStringFromVarFile(t, "./config/terratest.tfvars", "project_id")
	zone := terraform.GetVariableAsStringFromVarFile(t, "./config/terratest.tfvars", "zone")
	machineType := terraform.GetVariableAsStringFromVarFile(t, "./config/terratest.tfvars", "machine_type")

	// Get outputs
	instanceName := terraform.Output(t, terraformOptions, "instance_name")
	// svcAccEmail := terraform.Output(t, terraformOptions, "svc_acc_email")

	err = initGCPClient()
	if err != nil {
		t.Fatalf("error while creating GCP client: %s", err)
	}

	instance, err := getInstance(project, zone, instanceName)
	if err != nil {
		t.Fatalf("error while getting instance: %s", err)
	}

	// Check GCE instance attributes
	assert.Equal(t, instanceName, instance.Name)
	assert.Equal(t, fmt.Sprintf("https://www.googleapis.com/compute/v1/projects/%s/zones/%s", project, zone), instance.Zone)
	assert.Equal(t, fmt.Sprintf("https://www.googleapis.com/compute/v1/projects/%s/zones/%s/machineTypes/%s", project, zone, machineType), instance.MachineType)

	// svc, err := getServiceAccount(project, svcAccEmail)
	// if err != nil {
	// 	t.Fatalf("error while getting service account: %s", err)
	// }

	// assert.Equal(t, svcAccEmail, svc.Email)
}
