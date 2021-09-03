# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/role
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/data-sources/permissions
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor
# https://docs.datadoghq.com/api/latest/monitors/#create-a-monitor
# https://docs.datadoghq.com/account_management/rbac/?tab=datadogapplication
# https://docs.datadoghq.com/account_management/rbac/permissions/
# https://docs.datadoghq.com/api/latest/monitors/
# https://github.com/hashicorp/cdktf-provider-datadog/blob/main/API.md

# Get all available Datadog permissions
data "datadog_permissions" "available_permissions" {
  count = local.enabled ? 1 : 0
}

locals {
  enabled     = module.this.enabled
  permissions = local.enabled ? data.datadog_permissions.available_permissions[0].permissions : null
}
