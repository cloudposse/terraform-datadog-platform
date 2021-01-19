module "monitor_configs" {
  source  = "cloudposse/yaml/config"
  version = "0.6.0"

  map_config_local_base_path = path.module
  map_config_paths           = var.monitor_paths

  context = module.this.context
}

module "synthetic_configs" {
  source  = "cloudposse/yaml/config"
  version = "0.6.0"

  map_config_local_base_path = path.module
  map_config_paths           = var.synthetic_paths

  context = module.this.context
}

module "datadog_monitors" {
  source = "../../"

  datadog_monitors     = module.monitor_configs.map_configs
  datadog_synthetics   = module.synthetic_configs.map_configs
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}
