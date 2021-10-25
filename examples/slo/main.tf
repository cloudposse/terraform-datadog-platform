locals {
  slo_files = flatten([for p in var.slo_paths : fileset(path.module, p)])
  slo_list  = [for f in local.slo_files : yamldecode(file(f))]
  slo_map   = merge(local.slo_list...)
}

module "datadog_slo" {
  source = "../../modules/slo"

  datadog_slos = local.slo_map

  alert_tags = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}
