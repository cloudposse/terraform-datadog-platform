locals {
  alert_tags = module.this.enabled && var.alert_tags != null ? format("%s%s", var.alert_tags_separator, join(var.alert_tags_separator, var.alert_tags)) : ""
}

# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor
resource "datadog_monitor" "default" {
  for_each = module.this.enabled ? var.datadog_monitors : {}

  name                = each.value.name
  type                = each.value.type
  query               = each.value.query
  message             = format("%s%s", each.value.message, local.alert_tags)
  escalation_message  = lookup(each.value, "escalation_message", null)
  require_full_window = lookup(each.value, "require_full_window", null)
  notify_no_data      = lookup(each.value, "notify_no_data", null)
  new_host_delay      = lookup(each.value, "new_host_delay", null)
  evaluation_delay    = lookup(each.value, "evaluation_delay", null)
  no_data_timeframe   = lookup(each.value, "no_data_timeframe", null)
  renotify_interval   = lookup(each.value, "renotify_interval", null)
  notify_audit        = lookup(each.value, "notify_audit", null)
  timeout_h           = lookup(each.value, "timeout_h", null)
  include_tags        = lookup(each.value, "include_tags", null)
  enable_logs_sample  = lookup(each.value, "enable_logs_sample", null)
  locked              = lookup(each.value, "locked", null)
  force_delete        = lookup(each.value, "force_delete", null)
  threshold_windows   = lookup(each.value, "threshold_windows", null)
  thresholds          = lookup(each.value, "thresholds", null)

  tags = lookup(each.value, "tags", null)
}

resource "datadog_synthetics_test" "default" {
  for_each = module.this.enabled ? var.datadog_synthetics : {}

  name      = each.value.name
  message   = format("%s%s", each.value.message, local.alert_tags)
  type      = each.value.type
  subtype   = lookup(each.value, "subtype", null)
  status    = each.value.status
  locations = each.value.locations
  tags      = lookup(each.value, "tags", null)

  request = {
    host       = lookup(each.value, "request_host", null)
    port       = lookup(each.value, "request_port", null)
    url        = lookup(each.value, "request_url", null)
    method     = lookup(each.value, "request_method", "GET")
    timeout    = lookup(each.value, "request_timeout", null)
    body       = lookup(each.value, "request_body", null)
    dns_server = lookup(each.value, "request_dns_server", null)
  }

  request_headers = lookup(each.value, "request_headers", null)
  request_query   = lookup(each.value, "request_query", null)

  dynamic "assertion" {
    for_each = each.value.assertions

    content {
      type     = lookup(assertion.value, "type", null)
      operator = lookup(assertion.value, "operator", null)
      target   = lookup(assertion.value, "target", null)
      property = lookup(assertion.value, "target", null)
      dynamic "targetjsonpath" {
        for_each = lookup(assertion.value, "targetjsonpath", {})

        content {
          operator    = lookup(targetjsonpath.value, "operator", null)
          targetvalue = lookup(targetjsonpath.value, "targetvalue", null)
          jsonpath    = lookup(targetjsonpath.value, "jsonpath", null)
        }
      }
    }
  }

  options_list {
    tick_every           = lookup(each.value, "tick_every", 900)
    follow_redirects     = lookup(each.value, "follow_redirects", null)
    min_failure_duration = lookup(each.value, "min_failure_duration", null)
    min_location_failed  = lookup(each.value, "min_location_failed", null)
    accept_self_signed   = lookup(each.value, "accept_self_signed", null)
    allow_insecure       = lookup(each.value, "allow_insecure", null)

    dynamic "retry" {
      for_each = lookup(each.value, "retry", {})

      content {
        count    = retry.value.count
        interval = retry.value.interval
      }
    }

    dynamic "monitor_options" {
      for_each = lookup(each.value, "monitor_options", null) != null ? [1] : []

      content {
        renotify_interval = each.value.monitor_options.renotify_interval
      }
    }
  }
}
