module "datadog_monitors" {
  source = "../../"

  monitors_config_file = var.monitors_config_file
  monitors_enabled     = var.monitors_enabled
  alert_tags           = var.alert_tags
  monitor_tags         = var.monitor_tags

  context = module.this.context
}
