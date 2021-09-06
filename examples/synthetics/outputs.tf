output "datadog_synthetics_test_names" {
  value       = module.datadog_synthetics.datadog_synthetics_test_names
  description = "Names of the created Datadog synthetic tests"
}

output "datadog_synthetic_tests" {
  value       = module.datadog_synthetics.datadog_synthetic_tests
  description = "Synthetic tests created in DataDog"
}
