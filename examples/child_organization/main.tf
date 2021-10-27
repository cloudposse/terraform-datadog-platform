module "datadog_child_organization" {
  source = "../../modules/child_organization"

  organization_name                = var.organization_name
  saml_enabled                     = var.saml_enabled
  saml_autocreate_users_domains    = var.saml_autocreate_users_domains
  saml_autocreate_users_enabled    = var.saml_autocreate_users_enabled
  saml_idp_initiated_login_enabled = var.saml_idp_initiated_login_enabled
  saml_strict_mode_enabled         = var.saml_strict_mode_enabled
  private_widget_share             = var.private_widget_share
  saml_autocreate_access_role      = var.saml_autocreate_access_role

  context = module.this.context
}
