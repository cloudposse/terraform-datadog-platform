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
  description = "Datadog monitor outputs"
}
