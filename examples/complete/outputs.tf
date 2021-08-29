output "datadog_monitor_names" {
  value       = module.datadog_monitors.datadog_monitor_names
  description = "Names of the created Datadog monitors"
}

output "datadog_monitors" {
  value       = module.datadog_monitors
  description = "The created Datadog monitors"
}

output "datadog_available_permissions" {
  value       = local.available_permissions
  description = "Map of available permission names to permission IDs"
}
