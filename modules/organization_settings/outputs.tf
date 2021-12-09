output "id" {
  value       = try(datadog_organization_settings.default[0].id, "")
  description = "Organization settings ID"
}

output "description" {
  value       = try(datadog_organization_settings.default[0].description, "")
  description = "Description of the organization"
}

output "public_id" {
  value       = try(datadog_organization_settings.default[0].public_id, "")
  description = "Public ID of the organization"
}

output "settings" {
  value       = try(datadog_organization_settings.default[0].settings, {})
  description = "Organization settings"
}
