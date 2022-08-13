output "datadog_monitor_slos" {
  value       = module.datadog_slo.datadog_monitor_slos
  description = "Map of created monitor-based SLOs"
}

output "datadog_monitor_slo_monitors" {
  value       = module.datadog_slo.datadog_monitor_slo_monitors
  description = "Map of created monitors for the monitor-based SLOs"
}

output "datadog_metric_slos" {
  value       = module.datadog_slo.datadog_metric_slos
  description = "Map of created metric-based SLOs"
}

output "datadog_metric_slo_alerts" {
  value       = module.datadog_slo.datadog_metric_slo_alerts
  description = "Map of created metric-based SLO alerts"
}
