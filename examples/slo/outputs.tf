output "datadog_metric_slos" {
  value       = module.datadog_slo.datadog_metric_slos
  description = "Map of created Metric Based SLOs"
}

output "datadog_synthetics_test_ids" {
  value       = module.datadog_slo.datadog_monitor_slos
  description = "Map of created Monitor Based SLOs"
}
