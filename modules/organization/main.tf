locals {
  enabled = module.this.enabled
}

resource "datadog_child_organization" "default" {
  count = local.enabled ? 1 : 0
  name  = module.this.id
}

resource "datadog_organization_settings" "default" {
  count    = local.enabled ? 1 : 0
  name     = module.this.id
  settings = var.settings
}
