module "monitor_configs" {
  source  = "cloudposse/config/yaml"
  version = "0.8.1"

  map_config_local_base_path = path.module
  map_config_paths           = var.monitor_paths

  context = module.this.context
}

module "synthetic_configs" {
  source  = "cloudposse/config/yaml"
  version = "0.8.1"

  map_config_local_base_path = path.module
  map_config_paths           = var.synthetic_paths

  context = module.this.context
}

# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/role
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/data-sources/permissions
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor
# https://docs.datadoghq.com/account_management/rbac/?tab=datadogapplication
# https://docs.datadoghq.com/account_management/rbac/permissions/
# https://docs.datadoghq.com/api/latest/monitors/
# https://github.com/hashicorp/cdktf-provider-datadog/blob/main/API.md

# Get all available Datadog permissions
data "datadog_permissions" "permissions" {}

# Create separate roles for each monitor and assign permissions to the roles

module "datadog_monitors" {
  source = "../../"

  datadog_monitors     = module.monitor_configs.map_configs
  datadog_synthetics   = module.synthetic_configs.map_configs
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}
