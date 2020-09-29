output "datadog_monitor_names" {
  value       = values(datadog_monitor.default)[*].name
  description = "Names of the created Datadog monitors"
}

output "datadog_monitors_config" {
  value       = local.datadog_monitors
  description = "Datadog monitors configuration"
}
