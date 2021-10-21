locals {
  enabled = module.this.enabled

  datadog_monitor_slos = { for slo in var.datadog_slos : slo.name => slo if slo.type == "monitor" && local.enabled }
  datadog_metric_slos  = { for slo in var.datadog_slos : slo.name => slo if slo.type == "metric" && local.enabled }
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


  tags = lookup(each.value, "tags", module.this.tags)
}

resource "datadog_service_level_objective" "metric_slo" {
  for_each = local.datadog_metric_slos

  #  Required
  name = each.value.name
  type = each.value.type

  query {
    denominator = each.value.query.denominator
    numerator   = each.value.query.numerator
  }

  #  Optional
  description  = lookup(each.value, "description", null)
  force_delete = lookup(each.value, "force_delete", true)
  validate     = lookup(each.value, "validate", false)

  dynamic "thresholds" {
    for_each = each.value.thresholds
    content {
      target    = lookup(thresholds, "target", "99.00")
      timeframe = lookup(thresholds, "timeframe", "7d")

      target_display  = lookup(thresholds, "target_display", "97.00")
      warning         = lookup(thresholds, "warning", "99.95")
      warning_display = lookup(thresholds, "warning_display", "98.00")
    }
  }

  tags = lookup(each.value, "tags", module.this.tags)
}
