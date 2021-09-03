module "monitor_configs" {
  source  = "cloudposse/config/yaml"
  version = "0.8.1"

  map_config_local_base_path = path.module
  map_config_paths           = var.monitor_paths

  context = module.this.context
}

module "role_configs" {
  source  = "cloudposse/config/yaml"
  version = "0.8.1"

  map_config_local_base_path = path.module
  map_config_paths           = var.role_paths

  context = module.this.context
}

locals {
  # Example of assigning restricted roles with permissions to monitors.
  # See `catalog/monitors` for the available monitors.
  # See `catalog/roles` for the available roles.
  # Only these roles will have access to the monitors.
  # The Datadog users that are associated with the roles will have the corresponding monitor permissions

  monitors_write_role_name    = module.datadog_roles.datadog_roles["monitors-write"].name
  monitors_downtime_role_name = module.datadog_roles.datadog_roles["monitors-downtime"].name

  monitors_roles_map = {
    aurora-replica-lag              = [local.monitors_write_role_name, local.monitors_downtime_role_name]
    ec2-failed-status-check         = [local.monitors_write_role_name, local.monitors_downtime_role_name]
    redshift-health-status          = [local.monitors_downtime_role_name]
    k8s-deployment-replica-pod-down = [local.monitors_write_role_name]
  }
}

module "datadog_roles" {
  source = "../../modules/roles"

  datadog_roles = module.role_configs.map_configs

  context = module.this.context
}

module "datadog_monitors" {
  source = "../../modules/monitors"

  datadog_monitors     = module.monitor_configs.map_configs
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator
  restricted_roles_map = local.monitors_roles_map

  context = module.this.context
}
