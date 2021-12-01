locals {
  monitor_files = flatten([for p in var.monitor_paths : fileset(path.module, p)])
  monitor_list  = [for f in local.monitor_files : yamldecode(file(f))]
  monitor_map   = merge(local.monitor_list...)
}

module "datadog_monitors" {
  source = "../../modules/monitors"

  datadog_monitors     = local.monitor_map
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}
