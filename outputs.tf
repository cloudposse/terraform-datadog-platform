output "datadog_monitor_names" {
  value       = values(datadog_monitor.default)[*].name
  description = "Names of the created Datadog monitors"
}

output "datadog_synthetics_test_names" {
  value       = values(datadog_synthetics_test.default)[*].name
  description = "Names of the created Datadog Synthetic tests"
}

output "datadog_synthetic_tests" {
  value       = datadog_synthetics_test.default
  description = "The synthetic tests created in DataDog"
}
