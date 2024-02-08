package test

import (
	"testing"
)

// Test the Terraform module in examples/child_organization using Terratest.
// We can only create Datadog child organizations with terraform, but cannot destroy them
// Warning: Cannot delete organization. Remove organization by contacting support (https://docs.datadoghq.com/help/).
func DisabledTestExamplesChildOrganization(t *testing.T) {
	t.Parallel()
	/*
		randID := strings.ToLower(random.UniqueId())
		attributes := []string{randID}

		rootFolder := "../../"
		terraformFolderRelativeToRoot := "examples/child_organization"
		varFiles := []string{"fixtures.us-east-2.tfvars"}

		tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

		terraformOptions := &terraform.Options{
			// The path to where our Terraform code is located
			TerraformDir: tempTestFolder,
			Upgrade:      true,
			// Variables to pass to our Terraform code using -var-file options
			VarFiles: varFiles,
			Vars: map[string]interface{}{
				"attributes": attributes,
			},
		}

		// At the end of the test, run `terraform destroy` to clean up any resources that were created
		defer cleanup(t, terraformOptions, tempTestFolder)

		// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
		terraform.InitAndApply(t, terraformOptions)

		// Run `terraform output` to get the value of an output variable
		datadogChildOrgId := terraform.OutputList(t, terraformOptions, "id")
		// Verify we're getting back the outputs we expect
		assert.Greater(t, len(datadogChildOrgId), 0)

	*/
}
