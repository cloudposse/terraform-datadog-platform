output "name" {
  description = "Name of the child organization"
  value       = module.this.id
}

output "application_key" {
  description = "Application key value"
  value       = join("", datadog_child_organization.default.*.application_key.hash)
  sensitive   = true
}

output "api_key" {
  description = "API key value"
  value       = join("", datadog_child_organization.default.*.api_key.key)
  sensitive   = true
}
