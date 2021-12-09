# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/child_organization
# https://github.com/hashicorp/cdktf-provider-datadog/blob/main/API.md

locals {
  enabled = module.this.enabled
}

resource "datadog_organization_settings" "default" {
  count = local.enabled ? 1 : 0

  name = var.organization_name

  settings {
    saml {
      # Free and Trial organizations cannot enable SAML
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
