locals {
  synthetics_files = flatten([for p in var.synthetic_paths : fileset(path.module, p)])
  synthetics_list  = [for f in local.synthetics_files : yamldecode(file(f))]
  synthetics_map   = merge(local.synthetics_list...)
}

module "datadog_synthetics" {
  source = "../../modules/synthetics"

  datadog_synthetics   = local.synthetics_map
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  locations = ["aws:us-east-2"]
  context   = module.this.context
}
