module "yaml_config" {
  source  = "cloudposse/config/yaml"
  version = "0.1.0"

  map_config_local_base_path = path.module
  map_config_paths           = var.monitor_paths

  context = module.this.context
}

module "datadog_monitors" {
  source = "../../"

  datadog_monitors     = module.yaml_config.map_configs
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}
