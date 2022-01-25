output "id" {
  value       = try(datadog_child_organization.default[0].id, "")
  description = "Organization ID"
}

output "description" {
  value       = try(datadog_child_organization.default[0].description, "")
  description = "Description of the organization"
}

output "public_id" {
  value       = try(datadog_child_organization.default[0].public_id, "")
  description = "Public ID of the organization"
}

output "user" {
  value       = try(datadog_child_organization.default[0].user[0], {})
  description = "Information about organization users"
}

output "settings" {
  value       = try(datadog_child_organization.default[0].settings[0], {})
  description = "Organization settings"
}

output "api_key" {
  value       = try(datadog_child_organization.default[0].api_key[0], {})
  description = "Information about Datadog API key"
  sensitive   = true
}

output "application_key" {
  value       = try(datadog_child_organization.default[0].application_key[0], {})
  description = "Datadog application key with its associated metadata"
  sensitive   = true
}
