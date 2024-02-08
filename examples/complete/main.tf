locals {
  # Note that we do not follow the usual pattern of using the `attributes` in the resource ID.
  # This is because we do not have automatic cleanup of the monitors, and we want to avoid
  # leaving orphaned monitors around. This way, tests will fail if they find an orphaned
  # monitor already exists, and we will know to clean it up manually.
  legacy_monitor_files = flatten([for p in var.legacy_monitor_paths : fileset(path.module, p)])
  legacy_monitor_list  = [for f in local.legacy_monitor_files : yamldecode(file(f))]
  legacy_monitor_map   = merge(local.legacy_monitor_list...)

  json_monitor_files = flatten([for p in var.json_monitor_paths : fileset(path.module, p)])
  json_monitor_list  = [for f in local.json_monitor_files : jsondecode(file(f))]
  json_monitor_map   = { for v in local.json_monitor_list : v.name => v }

  monitor_map = merge(local.legacy_monitor_map, local.json_monitor_map)
}

module "datadog_monitors" {
  source = "../../modules/monitors"

  datadog_monitors     = local.monitor_map
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}
