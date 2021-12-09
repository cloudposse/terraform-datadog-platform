output "id" {
  value       = module.datadog_organization_settings.id
  description = "Organization ID"
}

output "description" {
  value       = module.datadog_organization_settings.description
  description = "Description of the organization"
}

output "public_id" {
  value       = module.datadog_organization_settings.public_id
  description = "Public ID of the organization"
}

output "settings" {
  value       = module.datadog_organization_settings.settings
  description = "Organization settings"
}
