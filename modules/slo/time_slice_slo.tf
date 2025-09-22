locals {
  datadog_time_slice_slos = { for slo in var.datadog_slos : slo.name => slo if slo.type == "time_slice" && lookup(slo, "enabled", true) && local.enabled }

  temp_datadog_time_slice_slo_error_budget_alerts = flatten([
    for name, slo in local.datadog_time_slice_slos : {
      slo      = slo
      slo_name = name
      alert    = slo.error_budget_alert
    }
    if lookup(slo, "error_budget_alert", null) != null && lookup(slo.error_budget_alert, "enabled", false)
  ])

  temp_datadog_time_slice_slo_burn_rate_alerts = flatten([
    for name, slo in local.datadog_time_slice_slos : {
      slo      = slo
      slo_name = name
      alert    = slo.burn_rate_alert
    }
    if lookup(slo, "burn_rate_alert", null) != null && lookup(slo.burn_rate_alert, "enabled", false)
  ])

  datadog_time_slice_slo_error_budget_alerts = { for alert in local.temp_datadog_time_slice_slo_error_budget_alerts : alert.slo_name => alert }
  datadog_time_slice_slo_burn_rate_alerts    = { for alert in local.temp_datadog_time_slice_slo_burn_rate_alerts : alert.slo_name => alert }
}

resource "datadog_service_level_objective" "time_slice_slo" {
  for_each = local.datadog_time_slice_slos

  name         = each.value.name
  type         = each.value.type
  description  = lookup(each.value, "description", null)
  force_delete = lookup(each.value, "force_delete", true)
  validate     = lookup(each.value, "validate", false)

  sli_specification {
    time_slice {
      query {
        formula {
          formula_expression = lookup(each.value.sli_specification.time_slice.query, "formula", null)
        }

        dynamic "query" {
          for_each = lookup(each.value.sli_specification.time_slice.query, "queries", [])
          content {
            metric_query {
              data_source = lookup(query.value, "data_source", null)
              name        = lookup(query.value, "name", null)
              query       = lookup(query.value, "query", null)
            }
          }
        }
      }
      comparator             = lookup(each.value.sli_specification.time_slice, "comparator", null)
      threshold              = lookup(each.value.sli_specification.time_slice, "threshold", null)
      query_interval_seconds = lookup(each.value.sli_specification.time_slice, "query_interval_seconds", null)
    }
  }

  dynamic "thresholds" {
    for_each = each.value.thresholds
    content {
      target    = lookup(thresholds.value, "target", null)
      timeframe = lookup(thresholds.value, "timeframe", null)
      warning   = lookup(thresholds.value, "warning", null)
    }
  }

  tags = [
    for tagk, tagv in lookup(each.value, "tags", module.this.tags) : (tagv != null ? format("%s:%s", tagk, tagv) : tagk)
  ]
}

resource "datadog_monitor" "time_slice_slo_error_budget_alert" {
  for_each = local.datadog_time_slice_slo_error_budget_alerts

  type    = "slo alert"
  name    = format("(SLO Error Budget Alert) %s", each.value.slo.name)
  message = format("%s %s", each.value.alert.message, local.alert_tags)

  query = <<EOF
    error_budget("${datadog_service_level_objective.time_slice_slo[each.value.slo_name].id}").over("${each.value.alert.timeframe}") > ${each.value.alert.threshold}
  EOF

  monitor_thresholds {
    critical = lookup(each.value.alert, "threshold", null)
  }

  validate = false

  include_tags = true
  priority     = lookup(each.value.alert, "priority", 5)

  tags = [
    for tagk, tagv in lookup(each.value.slo, "tags", {}) : (tagv != null ? format("%s:%s", tagk, tagv) : tagk)
  ]
}

resource "datadog_monitor" "time_slice_slo_burn_rate_alert" {
  for_each = local.datadog_time_slice_slo_burn_rate_alerts

  type    = "slo alert"
  name    = format("(SLO Burn Rate Alert) %s", each.value.slo.name)
  message = format("%s %s", each.value.alert.message, local.alert_tags)

  query = <<EOF
    burn_rate("${datadog_service_level_objective.time_slice_slo[each.value.slo_name].id}").over("${each.value.alert.timeframe}").long_window("${each.value.alert.long_window}").short_window("${each.value.alert.short_window}") > ${each.value.alert.threshold}
  EOF

  monitor_thresholds {
    critical = lookup(each.value.alert, "threshold", null)
  }

  validate     = false
  include_tags = true
  priority     = lookup(each.value.alert, "priority", 5)

  tags = [
    for tagk, tagv in lookup(each.value.slo, "tags", {}) : (tagv != null ? format("%s:%s", tagk, tagv) : tagk)
  ]
}
