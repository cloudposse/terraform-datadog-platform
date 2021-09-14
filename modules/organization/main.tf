locals {
  enabled = module.this.enabled
}

resource "datadog_child_organization" "default" {
  count       = local.enabled ? 1 : 0
  name        = module.this.id
  description = var.description
  settings    = var.settings
  user        = var.user
}
