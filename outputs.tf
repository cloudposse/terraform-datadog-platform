output "datadog_monitor_names" {
  value       = values(datadog_monitor.default)[*].name
  description = "Names of the created Datadog monitors"
}

output "datadog_synthetics_test_names" {
  value       = values(datadog_synthetics_test.default)[*].name
  description = "Names of the created Datadog Synthetic tests"
}
