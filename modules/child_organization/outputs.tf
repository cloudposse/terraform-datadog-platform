output "api_key" {
  value = datadog_child_organization.default.api_key
  description = "The API key for the root organization user"
}
output "application_key" {
  value = datadog_child_organization.default.application_key
  description = "The application key for the root organization user"
}
output "saml_idp_endpoint" {
  value       = datadog_organization_settings.default.settings[0].saml_idp_endpoint
  description = "The SAML IDP endpoint for the organization"
}

output "saml_login_url" {
  value = datadog_organization_settings.default.settings[0].saml_login_url
}