locals {
  enabled = module.this.enabled

  datadog_monitor_slos = { for slo in var.datadog_slos : slo.name => slo if slo.type == "monitor" && lookup(slo, "enabled", true) && local.enabled }
  datadog_metric_slos  = { for slo in var.datadog_slos : slo.name => slo if slo.type == "metric" && lookup(slo, "enabled", true) && local.enabled }

  temp_datadog_slo_metric_monitors = flatten([
    for name, slo in var.datadog_slos : [
      for i, threshold in slo.thresholds : {
        slo       = slo,
        slo_name  = format("%s_threshold%s", name, i)
        threshold = threshold
      }
      if slo.type == "metric" && local.enabled && lookup(slo, "enabled", true)
    ]
  ])

  datadog_slo_metric_monitors = { for monitor in local.temp_datadog_slo_metric_monitors : monitor.slo_name => monitor }

  alert_tags = local.enabled && var.alert_tags != null ? format("%s%s", var.alert_tags_separator, join(var.alert_tags_separator, var.alert_tags)) : ""
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
      target    = lookup(thresholds.value, "target", null)
      timeframe = lookup(thresholds.value, "timeframe", null)
      warning   = lookup(thresholds.value, "warning", null)
    }
  }

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

resource "datadog_monitor" "metric_slo_alert" {
  for_each = local.datadog_slo_metric_monitors

  name    = format("(SLO Error Budget Alert) %s", each.value.slo.name)
  type    = "slo alert"
  message = format("%s%s", each.value.slo.message, local.alert_tags)

  query = <<EOF
    error_budget("${datadog_service_level_objective.metric_slo[each.value.slo.name].id}").over("${each.value.threshold.timeframe}") > ${lookup(each.value.threshold, "target", "99.00")}
  EOF
  monitor_thresholds {
    critical = lookup(each.value.threshold, "target", null)
  }

  # Convert terraform tags map to Datadog tags map
  # If a key is supplied with a value, it will render "key:value" as a tag
  #   tags:
  #     key: value
  # If a key is supplied without a value (null), it will render "key" as a tag
  #   tags:
  #     key: null
  tags = [
    for tagk, tagv in lookup(each.value.slo, "tags", module.this.tags) : (tagv != null ? format("%s:%s", tagk, tagv) : tagk)
  ]
}
