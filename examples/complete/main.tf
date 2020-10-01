locals {
  datadog_monitors = yamldecode(file("monitors.yaml"))
}

module "datadog_monitors" {
  source = "../../"

  datadog_monitors     = local.datadog_monitors
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}
