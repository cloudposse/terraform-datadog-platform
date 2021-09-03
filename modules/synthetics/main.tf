locals {
  enabled    = module.this.enabled
  alert_tags = local.enabled && var.alert_tags != null ? format("%s%s", var.alert_tags_separator, join(var.alert_tags_separator, var.alert_tags)) : ""
}

resource "datadog_synthetics_test" "default" {
  for_each = local.enabled ? var.datadog_synthetics : {}

  name      = each.value.name
  message   = format("%s%s", each.value.message, local.alert_tags)
  type      = each.value.type
  subtype   = lookup(each.value, "subtype", null)
  status    = each.value.status
  locations = each.value.locations
  tags      = lookup(each.value, "tags", module.this.tags)

  request_definition {
    host       = lookup(each.value.request, "host", null)
    port       = lookup(each.value.request, "port", null)
    url        = lookup(each.value.request, "url", null)
    method     = lookup(each.value.request, "method", null)
    timeout    = lookup(each.value.request, "timeout", null)
    body       = lookup(each.value.request, "body", null)
    dns_server = lookup(each.value.request, "dns_server", null)
  }

  request_headers = each.value.request_headers
  request_query   = each.value.request_query

  dynamic "assertion" {
    for_each = each.value.assertions

    content {
      type     = lookup(assertion.value, "type", null)
      operator = lookup(assertion.value, "operator", null)
      target   = lookup(assertion.value, "target", null)
      property = lookup(assertion.value, "property", null)

      dynamic "targetjsonpath" {
        for_each = lookup(assertion.value, "targetjsonpath_operator", null) != null ? [1] : []

        content {
          operator    = assertion.value.targetjsonpath_operator
          targetvalue = assertion.value.targetjsonpath_targetvalue
          jsonpath    = assertion.value.targetjsonpath_jsonpath
        }
      }
    }
  }

  options_list {
    tick_every           = lookup(each.value.options, "tick_every", 900)
    follow_redirects     = lookup(each.value.options, "follow_redirects", false)
    min_failure_duration = lookup(each.value.options, "min_failure_duration", null)
    min_location_failed  = lookup(each.value.options, "min_location_failed", null)
    accept_self_signed   = lookup(each.value.options, "accept_self_signed", false)
    allow_insecure       = lookup(each.value.options, "allow_insecure", false)

    dynamic "retry" {
      for_each = lookup(each.value.options, "retry_count", null) != null ? [1] : []

      content {
        count    = each.value.options.retry_count
        interval = each.value.options.retry_interval
      }
    }

    dynamic "monitor_options" {
      for_each = lookup(each.value.options, "renotify_interval", null) != null ? [1] : []

      content {
        renotify_interval = each.value.options.renotify_interval
      }
    }
  }
}
