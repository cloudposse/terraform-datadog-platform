locals {
  datadog_monitor_slos = { for slo in var.datadog_slos : slo.name => slo if slo.type == "monitor" && lookup(slo, "enabled", true) && local.enabled }
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

      target_display  = lookup(thresholds, "target_display", "98.00")
      warning         = lookup(thresholds, "warning", "99.95")
      warning_display = lookup(thresholds, "warning_display", "98.00")
    }
  }

  groups      = lookup(each.value, "groups", [])
  monitor_ids = each.value.monitor_ids

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