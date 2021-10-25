output "datadog_metric_slos" {
  value       = datadog_service_level_objective.metric_slo[*]
  description = "Map of created Metric Based SLOs"
}

output "datadog_monitor_slos" {
  value       = datadog_service_level_objective.monitor_slo[*]
  description = "Map of created Monitor Based SLOs"
}

output "datadog_slo_alerts" {
  value       = datadog_monitor.metric_slo_alert
  description = "Map of created SLO Based Alerts"
}
