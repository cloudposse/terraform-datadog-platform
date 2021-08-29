output "datadog_monitor_names" {
  value       = module.datadog_monitors.datadog_monitor_names
  description = "Names of the created Datadog monitors"
}

output "datadog_permissions" {
  value       = data.datadog_permissions.permissions.permissions
  description = "Map of available permission names to permission IDs"
}
