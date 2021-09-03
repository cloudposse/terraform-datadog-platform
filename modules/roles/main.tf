locals {
  enabled = module.this.enabled
}

resource "datadog_role" "default" {
  for_each = local.enabled ? var.datadog_roles : {}

  name = each.value.name

  dynamic "permission" {
    for_each = each.value.permissions
    content {
      id = permission.value
    }
  }
}
