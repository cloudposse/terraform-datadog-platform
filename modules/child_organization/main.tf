# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/child_organization
# https://github.com/hashicorp/cdktf-provider-datadog/blob/main/API.md

locals {
  enabled = module.this.enabled
}

resource "datadog_child_organization" "default" {
  count = local.enabled ? 1 : 0
  name  = var.organization_name
}
