output "datadog_monitor_names" {
  value       = values(datadog_monitor.default)[*].name
  description = "Names of the created Datadog monitors"
}

output "datadog_monitor_ids" {
  value       = values(datadog_monitor.default)[*].id
  description = "IDs of the created Datadog monitors"
}

output "datadog_monitors" {
  value       = datadog_monitor.default
  description = "A list of the actual monitor objects."
}

output "datadog_synthetics_test_names" {
  value       = values(datadog_synthetics_test.default)[*].name
  description = "Names of the created Datadog Synthetic tests"
}

output "datadog_synthetic_tests" {
  value       = datadog_synthetics_test.default
  description = "The synthetic tests created in DataDog"
}
