locals {
  datadog_monitors = yamldecode(file("monitors.yaml"))
}

module "datadog_monitors" {
  source = "../../"

  datadog_monitors = local.datadog_monitors
  alert_tags       = var.alert_tags

  context = module.this.context
}
