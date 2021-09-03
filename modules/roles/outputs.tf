output "datadog_role_names" {
  value       = values(datadog_role.default)[*].name
  description = "Names of the created Datadog roles"
}

output "datadog_role_ids" {
  value       = values(datadog_role.default)[*].id
  description = "IDs of the created Datadog roles"
}

output "datadog_roles" {
  value       = datadog_role.default
  description = "Created Datadog roles"
}
