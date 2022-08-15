locals {
  datadog_monitor_slos = { for slo in var.datadog_slos : slo.name => slo if slo.type == "monitor" && lookup(slo, "enabled", true) && local.enabled }
}

module "datadog_monitors" {
  source = "../monitors"

  for_each = local.datadog_monitor_slos

  datadog_monitors     = lookup(each.value, "monitors", {})
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}

resource "datadog_service_level_objective" "monitor_slo" {
  for_each = local.datadog_monitor_slos

  #  Required
  name = each.value.name
  type = each.value.type

  dynamic "thresholds" {
    for_each = each.value.thresholds
    content {
      target    = lookup(thresholds, "target", "99.00")
      timeframe = lookup(thresholds, "timeframe", "7d")
      warning   = lookup(thresholds, "warning", "99.95")
    }
  }

  groups = lookup(each.value, "groups", [])

  # Either `monitor_ids` or `monitors` should be provided
  # If `monitors` map is provided, the monitors are created in the `datadog_monitors` module
  monitor_ids = try(each.value.monitor_ids, null) != null ? each.value.monitor_ids : module.datadog_monitors[each.key].datadog_monitor_ids

  #  Optional
  description  = lookup(each.value, "description", null)
  force_delete = lookup(each.value, "force_delete", true)
  validate     = lookup(each.value, "validate", false)

  # Convert terraform tags map to Datadog tags map
  # If a key is supplied with a value, it will render "key:value" as a tag
  #   tags:
  #     key: value
  # If a key is supplied without a value (null), it will render "key" as a tag
  #   tags:
  #     key: null
  tags = [
    for tagk, tagv in lookup(each.value, "tags", module.this.tags) : (tagv != null ? format("%s:%s", tagk, tagv) : tagk)
  ]
}
