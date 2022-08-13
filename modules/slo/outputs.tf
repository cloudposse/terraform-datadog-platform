output "datadog_monitor_slos" {
  value       = datadog_service_level_objective.monitor_slo
  description = "Map of created monitor-based SLOs"
}

output "datadog_monitor_slo_monitors" {
  value       = module.datadog_monitors.datadog_monitors
  description = "Map of created monitors for the monitor-based SLOs"
}

output "datadog_metric_slos" {
  value       = datadog_service_level_objective.metric_slo
  description = "Map of created metric-based SLOs"
}

output "datadog_metric_slo_alerts" {
  value       = datadog_monitor.metric_slo_alert
  description = "Map of created metric-based SLO alerts"
}
