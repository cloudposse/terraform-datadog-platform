locals {
  datadog_metric_slos = { for slo in var.datadog_slos : slo.name => slo if slo.type == "metric" && lookup(slo, "enabled", true) && local.enabled }

  temp_datadog_metric_slo_alerts = flatten([
    for name, slo in var.datadog_slos : [
      for i, threshold in slo.thresholds : {
        slo       = slo,
        slo_name  = format("%s_threshold%s", name, i)
        threshold = threshold
      }
      if slo.type == "metric" && local.enabled && lookup(slo, "enabled", true)
    ]
  ])

  datadog_metric_slo_alerts = { for monitor in local.temp_datadog_metric_slo_alerts : monitor.slo_name => monitor }
}

resource "datadog_service_level_objective" "metric_slo" {
  for_each = local.datadog_metric_slos

  #  Required
  name = each.value.name
  type = each.value.type

  #  Optional
  description  = lookup(each.value, "description", null)
  force_delete = lookup(each.value, "force_delete", true)
  validate     = lookup(each.value, "validate", false)

  query {
    denominator = each.value.query.denominator
    numerator   = each.value.query.numerator
  }

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
  for_each = local.datadog_metric_slo_alerts

  name    = format("(SLO Error Budget Alert) %s", each.value.slo.name)
  type    = "slo alert"
  message = format("%s%s", each.value.slo.message, local.alert_tags)

  query = <<EOF
    error_budget("${datadog_service_level_objective.metric_slo[each.value.slo.name].id}").over("${each.value.threshold.timeframe}") > ${lookup(each.value.threshold, "target", "99.00")}
  EOF

  force_delete = lookup(each.value, "force_delete", true)

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
