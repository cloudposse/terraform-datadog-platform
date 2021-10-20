
output "datadog_metric_slos" {
  value       = datadog_service_level_objective.metric_slo[*]
  description = "Names of the created Datadog monitors"
}
output "datadog_monitor_slos" {
  value       = datadog_service_level_objective.monitor_slo[*]
  description = "Names of the created Datadog monitors"
}
