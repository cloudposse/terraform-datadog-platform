# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/child_organization
# https://github.com/hashicorp/cdktf-provider-datadog/blob/main/API.md

# Create a new Datadog Child Organization
resource "datadog_child_organization" "default" {
  name = var.name
}

resource "datadog_organization_settings" {

  saml = [{
    enabled = var.saml_enabled
  }]

  saml_autocreate_users_domains = [{
    domains = var.saml_autocreate_users_domains
    enabled = len(var.saml_autocreate_users_domains) > 0 ? true : false
  }]

  saml_idp_initiated_login = [{
    enabled = var.saml_idp_initiated_login_enabled
  }]

  saml_strict_mode = [{
    enabled = var.saml_strict_mode_enabled
  }]

  private_widget_share = var.private_widget_share

  saml_autocreate_access_role = var.saml_autocreate_access_role
}

locals {
  enabled     = module.this.enabled
}
