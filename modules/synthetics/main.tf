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

  request_headers = try(each.value.request_headers, null)
  request_query   = try(each.value.request_query, null)
  set_cookie      = try(each.value.set_cookie, null)

  dynamic "assertion" {
    for_each = each.value.assertion

    content {
      type     = lookup(assertion.value, "type", null)
      operator = lookup(assertion.value, "operator", null)
      target   = lookup(assertion.value, "target", null)
      property = lookup(assertion.value, "property", null)

      dynamic "targetjsonpath" {
        for_each = lookup(assertion.value, "targetjsonpath", null) != null ? [1] : []

        content {
          operator    = targetjsonpath.value.operator
          targetvalue = targetjsonpath.value.targetvalue
          jsonpath    = targetjsonpath.value.jsonpath
        }
      }
    }
  }

  request_definition {
    host                    = lookup(each.value.request_definition, "host", null)
    port                    = lookup(each.value.request_definition, "port", null)
    url                     = lookup(each.value.request_definition, "url", null)
    method                  = lookup(each.value.request_definition, "method", null)
    timeout                 = lookup(each.value.request_definition, "timeout", null)
    body                    = lookup(each.value.request_definition, "body", null)
    dns_server              = lookup(each.value.request_definition, "dns_server", null)
    dns_server_port         = lookup(each.value.request_definition, "dns_server_port", null)
    no_saving_response_body = lookup(each.value.request_definition, "no_saving_response_body", null)
    number_of_packets       = lookup(each.value.request_definition, "number_of_packets", null)
    should_track_hops       = lookup(each.value.request_definition, "should_track_hops", null)
  }

  options_list {
    tick_every           = lookup(each.value.options_list, "tick_every", 900)
    follow_redirects     = lookup(each.value.options_list, "follow_redirects", false)
    min_failure_duration = lookup(each.value.options_list, "min_failure_duration", null)
    min_location_failed  = lookup(each.value.options_list, "min_location_failed", null)
    accept_self_signed   = lookup(each.value.options_list, "accept_self_signed", false)
    allow_insecure       = lookup(each.value.options_list, "allow_insecure", false)
    monitor_name         = lookup(each.value.options_list, "monitor_name", null)
    monitor_priority     = lookup(each.value.options_list, "monitor_priority", null)
    no_screenshot        = lookup(each.value.options_list, "no_screenshot", true)

    dynamic "retry" {
      for_each = lookup(each.value.options_list, "retry", null) != null ? [1] : []

      content {
        count    = retry.value.count
        interval = retry.value.interval
      }
    }

    dynamic "monitor_options" {
      for_each = lookup(each.value.options_list, "monitor_options", null) != null ? [1] : []

      content {
        renotify_interval = monitor_options.value.renotify_interval
      }
    }
  }
}
