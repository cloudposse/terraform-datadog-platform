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
# https://docs.datadoghq.com/api/latest/monitors/#create-a-monitor
# https://docs.datadoghq.com/account_management/rbac/?tab=datadogapplication
# https://docs.datadoghq.com/account_management/rbac/permissions/
# https://docs.datadoghq.com/api/latest/monitors/
# https://github.com/hashicorp/cdktf-provider-datadog/blob/main/API.md

# Get all available Datadog permissions
data "datadog_permissions" "available_permissions" {}

locals {
  available_permissions = data.datadog_permissions.available_permissions.permissions
}

# Create Datadog roles with different permission sets
# These roles must be assigned to Datadog users in order for the user to be assigned the corresponding monitor permissions
resource "datadog_role" "monitors_write_and_downtime" {
  name = "allow_monitors_write_and_downtime"
  permission {
    id = local.available_permissions.monitors_downtime
  }
  permission {
    id = local.available_permissions.monitors_write
  }
}

# Create roles with different permission sets
resource "datadog_role" "monitors_write" {
  name = "allow_monitors_write"
  permission {
    id = local.available_permissions.monitors_write
  }
}

resource "datadog_role" "monitors_downtime" {
  name = "allow_monitors_downtime"
  permission {
    id = local.available_permissions.monitors_downtime
  }
}

# Assign roles to monitors
locals {
  # Example of assigning restricted roles with permissions to monitors (see `catalog/monitors` for the available monitor names)
  # Only these roles will have access to the monitors
  # The Datadog users that are associated with the roles will have the corresponding monitor permisisons
  restricted_roles_map = {
    aurora-replica-lag              = [datadog_role.monitors_write_and_downtime.name]
    ec2-failed-status-check         = [datadog_role.monitors_write.name]
    redshift-health-status          = [datadog_role.monitors_write.name, datadog_role.monitors_downtime.name]
    k8s-deployment-replica-pod-down = [datadog_role.monitors_downtime.name]
  }
}

module "datadog_monitors" {
  source = "../../"

  datadog_monitors     = module.monitor_configs.map_configs
  datadog_synthetics   = module.synthetic_configs.map_configs
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator
  restricted_roles_map = local.restricted_roles_map

  context = module.this.context
}
