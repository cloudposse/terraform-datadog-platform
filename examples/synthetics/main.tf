locals {
  tf_synthetics_files = flatten([for p in var.terraform_synthetic_paths : fileset(path.module, p)])
  tf_synthetics_list  = [for f in local.tf_synthetics_files : yamldecode(file(f))]
  tf_synthetics_map   = merge(local.tf_synthetics_list...)

  api_synthetics_files = flatten([for p in var.api_synthetic_paths : fileset(path.module, p)])
  api_synthetics_list  = [for f in local.api_synthetics_files : yamldecode(file(f))]
  api_synthetics_map   = merge(local.api_synthetics_list...)
}

module "datadog_synthetics" {
  source = "../../modules/synthetics"

  datadog_synthetics   = merge(local.tf_synthetics_map, local.api_synthetics_map)
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  locations = ["aws:us-east-2"]
  context   = module.this.context
}
