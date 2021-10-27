output "id" {
  value       = module.datadog_child_organization.id
  description = "Organization ID"
}

output "description" {
  value       = module.datadog_child_organization.description
  description = "Description of the organization"
}

output "public_id" {
  value       = module.datadog_child_organization.public_id
  description = "Public ID of the organization"
}

output "user" {
  value       = module.datadog_child_organization.user
  description = "Information about organization users"
}

output "settings" {
  value       = module.datadog_child_organization.settings
  description = "Organization settings"
}
