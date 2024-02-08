package test

import (
	"errors"
	"fmt"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"os"
	"strings"
	"testing"
)

func cleanup(t *testing.T, terraformOptions *terraform.Options, tempTestFolder string) {
	terraform.Destroy(t, terraformOptions)
	os.RemoveAll(tempTestFolder)
}

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()
	randID := strings.ToLower(random.UniqueId())
	attributes := []string{randID}

	rootFolder := "../../"
	terraformFolderRelativeToRoot := "examples/complete"
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
	// Keep the output quiet
	if true || !testing.Verbose() {
		terraformOptions.Logger = logger.Discard
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer cleanup(t, terraformOptions, tempTestFolder)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	datadogMonitorNames := terraform.OutputList(t, terraformOptions, "datadog_monitor_names")
	// Verify we're getting back the outputs we expect
	assert.Greater(t, len(datadogMonitorNames), 0)

	// Ensure legacy scheduling options are preserved
	//output := terraform.OutputMapOfObjects(t, terraformOptions, "datadog_monitors")
	output := terraform.OutputForKeys(t, terraformOptions, []string{"datadog_monitors"})["datadog_monitors"].(map[string]interface{})

	var keys []string
	keys = []string{"anomaly-recovery-legacy-test", "anomaly-recovery-test"}

	for _, key := range keys {
		if assert.Contains(t, output, key, fmt.Sprintf("Did not find monitor with key '%s' in output", key)) {
			windows, conversionErr := extractMonitorThresholdWindows(output[key])
			if assert.NoError(t, conversionErr, fmt.Sprintf("Extracting threshold_windows from '%s' failed", key)) {
				if assert.Contains(t, windows, "recovery_window", fmt.Sprintf("Did not find recovery_window in threshold_windows for '%s'", key)) {
					assert.Equal(t, "last_1h", windows["recovery_window"], fmt.Sprintf("Anomaly monitor recovery window for '%s' should be 'last_1h'", key))
				}
				if assert.Contains(t, windows, "trigger_window", fmt.Sprintf("Did not find trigger_window in threshold_windows for '%s'", key)) {
					assert.Equal(t, "last_37m", windows["trigger_window"], fmt.Sprintf("Anomaly monitor trigger window for '%s' should be 'last_37m'", key))
				}
			}
		}
	}

	// keys = []string{"schedule-legacy-test", "schedule-test"}
	keys = []string{"schedule-legacy-test", "schedule-test"}

	for _, key := range keys {
		if assert.Contains(t, output, key, fmt.Sprintf("Did not find monitor with key '%s' in output", key)) {
			hourStart, conversionErr := extractEvaluationWindowHourStarts(output[key])
			if assert.NoError(t, conversionErr, fmt.Sprintf("Extracting hour_starts from evaluation_window for '%s' failed", key)) {
				assert.Equal(t, "7", hourStart, fmt.Sprintf("Scheduled Evaluation Window Hour starts for '%s' should be 7", key))
			}
		}
	}

	// Ensure tags are managed properly
	// However, skip the tests is something previously failed, so that we can avoid redundant error messages
	if !t.Failed() {
		var tags []string
		var err error

		// anomaly-recovery-legacy-test has a specific tag set as a map, should not have default tags
		tags, err = extractMonitorTags(output["anomaly-recovery-legacy-test"])
		if assert.NoError(t, err, "Extracting tags from anomaly-recovery-legacy-test failed") {
			assert.Contains(t, tags, "ManagedBy:Terraform", "Monitor 'anomaly-recovery-legacy-test' should have a 'ManagedBy:Terraform' tag")
			assert.Contains(t, tags, "Terratest", "Monitor 'anomaly-recovery-legacy-test' should have a 'Terratest' tag")
			assert.NotContains(t, tags, "Stage:test", "Monitor 'anomaly-recovery-legacy-test' should not have default tag 'Stage:test'")
		}

		// anomaly-recovery-test should have no tags
		assert.Nil(t, output["anomaly-recovery-test"].(map[string]interface{})["tags"], "Monitor 'anomaly-recovery-test' should have no tags")

		// schedule-legacy-test has no tags defined, should have default tags
		tags, err = extractMonitorTags(output["schedule-legacy-test"])
		if assert.NoError(t, err, "Extracting tags from schedule-legacy-test failed") {
			assert.Contains(t, tags, "Attributes:"+randID, "Monitor 'schedule-legacy-test' should have the 'Attributes:"+randID+"' tag")
			assert.Contains(t, tags, "Stage:test", "Monitor 'schedule-legacy-test' should have a 'Stage:test' tag")
			assert.NotContains(t, tags, "Terratest", "Monitor 'schedule-legacy-test' should not have a 'Terratest' tag")
		}

		// schedule-test has a specific tag set as a list, should not have default tags
		tags, err = extractMonitorTags(output["schedule-test"])
		if assert.NoError(t, err, "Extracting tags from schedule-test failed") {
			assert.Contains(t, tags, "test:examplemonitor", "Monitor 'schedule-test' should have a 'test:examplemonitor' tag")
			assert.NotContains(t, tags, "Stage:test", "Monitor 'schedule-test' should not have default tag 'Stage:test'")
		}
	}
}

func extractMonitorTags(value interface{}) (result []string, err error) {
	defer func() {
		if r := recover(); r != nil {
			// A panic occurred, return nil and a custom error
			result = nil
			err = errors.New("unable to find tags in output")
		}
	}()

	if converted, ok := value.(map[string]interface{})["tags"].([]interface{}); ok {
		for _, v := range converted {
			if str, ok := v.(string); ok {
				result = append(result, str)
			} else {
				return nil, errors.New("conversion to []string failed")
			}
		}
		return result, nil
	} else {
		return nil, errors.New("conversion to []string failed")
	}
}

func extractMonitorThresholdWindows(value interface{}) (result map[string]interface{}, err error) {
	defer func() {
		if r := recover(); r != nil {
			// A panic occurred, return zero and a custom error
			result = nil
			err = errors.New("unable to find monitor threshold_windows in output")
		}
	}()

	if converted, ok := value.(map[string]interface{})["monitor_threshold_windows"].([]interface{}); ok {
		return converted[0].(map[string]interface{}), nil
	} else {
		return nil, errors.New("conversion to map[string]string failed")
	}
}

func extractEvaluationWindowHourStarts(value interface{}) (result string, err error) {
	defer func() {
		if r := recover(); r != nil {
			// A panic occurred, return zero and a custom error
			result = ""
			err = errors.New("unable to find hour_starts in evaluation_window")
		}
	}()

	if converted, ok := value.(map[string]interface{})["scheduling_options"].([]interface{})[0].(map[string]interface{})["evaluation_window"].([]interface{})[0].(map[string]interface{})["hour_starts"]; ok {
		return fmt.Sprintf("%v", converted), nil
	} else {
		return "", errors.New("conversion to string failed")
	}
}

// .(map[string]interface{})["evaluation_window"])
// .([]map[string]interface{})[0].(map[string]int)["hour_starts"]
func TestExamplesCompleteDisabled(t *testing.T) {
	t.Parallel()
	randID := strings.ToLower(random.UniqueId())
	attributes := []string{randID}

	rootFolder := "../../"
	terraformFolderRelativeToRoot := "examples/complete"
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
			"enabled":    "false",
		},
	}
	// Keep the output quiet
	if !testing.Verbose() {
		terraformOptions.Logger = logger.Discard
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer cleanup(t, terraformOptions, tempTestFolder)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Get all the output and lookup a field. Pass if the field is missing or empty.
	datadogMonitorNames := terraform.OutputAll(t, terraformOptions)["datadog_monitor_names"]

	// Verify we're getting back the outputs we expect
	assert.Empty(t, datadogMonitorNames, "When disabled, module should have no outputs.")
}
