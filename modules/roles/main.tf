locals {
  enabled     = module.this.enabled
  permissions = module.permissions.permissions
}

module "permissions" {
  source  = "../permissions"
  context = module.this.context
}

resource "datadog_role" "default" {
  for_each = local.enabled ? var.datadog_roles : {}

  name = each.value.name

  dynamic "permission" {
    for_each = each.value.permissions
    content {
      id = local.permissions != null ? lookup(local.permissions, permission.value, null) : null
    }
  }
}
