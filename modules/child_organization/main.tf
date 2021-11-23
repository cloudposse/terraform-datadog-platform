# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/child_organization
# https://github.com/hashicorp/cdktf-provider-datadog/blob/main/API.md

locals {
  enabled = module.this.enabled
}

# Creates a new organization
resource "datadog_child_organization" "default" {
  count = local.enabled ? 1 : 0
  name  = var.organization_name
}

# Sets a new provider
provider "datadog" {
  alias = "organization"
  
  validate = local.enabled
  
  datadog_api_key = local.enabled ? join("", datadog_child_organization.default.*.api_key) : null
  datadog_app_key = local.enabled ? join("", datadog_child_organization.default.*.application_key) : null
}

# Set organization settings for the new org
# If provider is not set, it will try to modify the root org settings
resource "datadog_organization_settings" "default" {
  count = local.enabled ? 1 : 0

  name = var.organization_name
  
  providers = datadog.organization

  settings {
    saml {
      enabled = var.saml_enabled
    }

    saml_autocreate_users_domains {
      domains = var.saml_autocreate_users_domains
      enabled = var.saml_autocreate_users_enabled
    }

    saml_strict_mode {
      enabled = var.saml_strict_mode_enabled
    }

    saml_idp_initiated_login {
      enabled = var.saml_idp_initiated_login_enabled
    }

    private_widget_share = var.private_widget_share

    saml_autocreate_access_role = var.saml_autocreate_access_role
  }
}
