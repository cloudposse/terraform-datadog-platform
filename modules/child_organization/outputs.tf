output "saml_idp_endpoint" {
    value = resource.datadog_organization_settings.saml_idp_endpoint
    description = "The SAML IDP endpoint for the organization"
}

output "saml_login_url" {
    value = resource.datadog_organization_settings.saml_login_url
}