output "datadog_synthetics_test_names" {
  value       = values(datadog_synthetics_test.default)[*].name
  description = "Names of the created Datadog Synthetic tests"
}

output "datadog_synthetics_test_ids" {
  value       = values(datadog_synthetics_test.default)[*].id
  description = "IDs of the created Datadog synthetic tests"
}

output "datadog_synthetics_test_monitor_ids" {
  value       = values(datadog_synthetics_test.default)[*].monitor_id
  description = "IDs of the monitors associated with the Datadog synthetics tests"
}

output "datadog_synthetic_tests" {
  value       = datadog_synthetics_test.default
  description = "The synthetic tests created in DataDog"
}
