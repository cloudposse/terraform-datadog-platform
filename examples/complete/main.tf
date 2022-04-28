locals {
  monitor_files = flatten([for p in var.monitor_paths : fileset(path.module, p)])
  monitor_list  = [for f in local.monitor_files : yamldecode(file(f))]
  monitor_map   = merge(local.monitor_list...)

  synthetic_files = flatten([for p in var.synthetic_paths : fileset(path.module, p)])
  synthetic_list  = [for f in local.synthetic_files : yamldecode(file(f))]
  synthetic_map   = merge(local.synthetic_list...)

  slo_files = flatten([for p in var.slo_paths : fileset(path.module, p)])
  slo_list  = [for f in local.slo_files : yamldecode(file(f))]
  slo_map   = merge(local.slo_list...)
}

module "datadog_monitors" {
  source = "../../modules/monitors"

  datadog_monitors     = local.monitor_map
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}


module "datadog_synthetics" {
  source = "../../modules/synthetics"

  datadog_synthetics   = local.synthetic_map
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}

module "datadog_slos" {
  source = "../../modules/slo"

  datadog_slos         = local.slo_map
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}
