locals {
  enabled            = module.this.enabled
  alert_tags         = local.enabled && var.alert_tags != null ? format("%s%s", var.alert_tags_separator, join(var.alert_tags_separator, var.alert_tags)) : ""
  datadog_synthetics = { for k, v in var.datadog_synthetics : k => v if local.enabled }
}

resource "datadog_synthetics_test" "default" {
  for_each = local.datadog_synthetics

  name    = each.value.name
  message = format("%s%s", each.value.message, local.alert_tags)
  type    = each.value.type
  subtype = lookup(each.value, "subtype", null)
  status  = each.value.status
  tags    = lookup(each.value, "tags", module.this.tags)

  request_headers = try(each.value.request_headers, null)
  request_query   = try(each.value.request_query, null)
  set_cookie      = try(each.value.set_cookie, null)
  device_ids      = try(each.value.device_ids, null)

  locations = try(each.value.locations, var.locations)

  dynamic "assertion" {
    for_each = try(each.value.assertion, [])

    content {
      type     = lookup(assertion.value, "type", null)
      operator = lookup(assertion.value, "operator", null)
      target   = lookup(assertion.value, "target", null)
      property = lookup(assertion.value, "property", null)

      dynamic "targetjsonpath" {
        for_each = lookup(assertion.value, "targetjsonpath", null) != null ? [1] : []

        content {
          operator    = assertion.value.targetjsonpath.operator
          targetvalue = assertion.value.targetjsonpath.targetvalue
          jsonpath    = assertion.value.targetjsonpath.jsonpath
        }
      }
    }
  }

  dynamic "request_definition" {
    for_each = lookup(each.value, "request_definition", null) != null ? [1] : []

    content {
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
  }

  dynamic "options_list" {
    for_each = lookup(each.value, "options_list", null) != null ? [1] : []

    content {
      tick_every           = lookup(each.value.options_list, "tick_every", 600)
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
          count    = each.value.options_list.retry.count
          interval = each.value.options_list.retry.interval
        }
      }

      dynamic "monitor_options" {
        for_each = lookup(each.value.options_list, "monitor_options", null) != null ? [1] : []

        content {
          renotify_interval = each.value.options_list.monitor_options.renotify_interval
        }
      }
    }
  }

  dynamic "api_step" {
    for_each = try(each.value.api_step, [])

    content {
      name            = api_step.value.name
      subtype         = lookup(api_step.value, "subtype", false)
      allow_failure   = lookup(api_step.value, "allow_failure", false)
      is_critical     = lookup(api_step.value, "is_critical", false)
      request_headers = lookup(api_step.value, "request_headers", false)
      request_query   = lookup(api_step.value, "request_query", false)

      dynamic "assertion" {
        for_each = try(api_step.value.assertion, [])

        content {
          type     = lookup(assertion.value, "type", null)
          operator = lookup(assertion.value, "operator", null)
          target   = lookup(assertion.value, "target", null)
          property = lookup(assertion.value, "property", null)

          dynamic "targetjsonpath" {
            for_each = lookup(assertion.value, "targetjsonpath", null) != null ? [1] : []

            content {
              operator    = assertion.value.targetjsonpath.operator
              targetvalue = assertion.value.targetjsonpath.targetvalue
              jsonpath    = assertion.value.targetjsonpath.jsonpath
            }
          }
        }
      }

      dynamic "extracted_value" {
        for_each = try(api_step.value.extracted_value, [])

        content {
          name  = lookup(extracted_value.value, "name", null)
          type  = lookup(extracted_value.value, "type", null)
          field = lookup(extracted_value.value, "field", null)

          dynamic "parser" {
            for_each = lookup(extracted_value.value, "parser", null) != null ? [1] : []

            content {
              type  = extracted_value.value.parser.type
              value = extracted_value.value.parser.value
            }
          }
        }
      }

      dynamic "request_basicauth" {
        for_each = lookup(api_step.value, "request_basicauth", null) != null ? [1] : []

        content {
          password = api_step.value.request_basicauth.password
          username = api_step.value.request_basicauth.username
        }
      }

      dynamic "request_client_certificate" {
        for_each = lookup(api_step.value, "request_client_certificate", null) != null ? [1] : []

        content {
          dynamic "cert" {
            for_each = lookup(api_step.value.request_client_certificate, "cert", null) != null ? [1] : []

            content {
              content  = api_step.value.request_client_certificate.cert.content
              filename = try(api_step.value.request_client_certificate.cert.filename, null)
            }
          }
          dynamic "key" {
            for_each = lookup(api_step.value.request_client_certificate, "key", null) != null ? [1] : []

            content {
              content  = api_step.value.request_client_certificate.key.content
              filename = try(api_step.value.request_client_certificate.key.filename, null)
            }
          }
        }
      }

      dynamic "request_definition" {
        for_each = lookup(api_step.value, "request_definition", null) != null ? [1] : []

        content {
          allow_insecure          = lookup(api_step.value.request_definition, "allow_insecure", null)
          body                    = lookup(api_step.value.request_definition, "body", null)
          dns_server              = lookup(api_step.value.request_definition, "dns_server", null)
          dns_server_port         = lookup(api_step.value.request_definition, "dns_server_port", null)
          host                    = lookup(api_step.value.request_definition, "host", null)
          method                  = lookup(api_step.value.request_definition, "method", null)
          no_saving_response_body = lookup(api_step.value.request_definition, "no_saving_response_body", null)
          number_of_packets       = lookup(api_step.value.request_definition, "number_of_packets", null)
          port                    = lookup(api_step.value.request_definition, "port", null)
          should_track_hops       = lookup(api_step.value.request_definition, "should_track_hops", null)
          timeout                 = lookup(api_step.value.request_definition, "timeout", null)
          url                     = lookup(api_step.value.request_definition, "url", null)
        }
      }

    }
  }

  dynamic "browser_step" {
    for_each = try(each.value.browser_step, [])

    content {
      name                 = browser_step.value.name
      type                 = browser_step.value.type
      allow_failure        = lookup(browser_step.value, "allow_failure", null)
      force_element_update = lookup(browser_step.value, "force_element_update", null)
      timeout              = lookup(browser_step.value, "timeout", null)

      params {
        attribute         = try(browser_step.value.params.attribute, null)
        check             = try(browser_step.value.params.check, null)
        click_type        = try(browser_step.value.params.click_type, null)
        code              = try(browser_step.value.params.code, null)
        delay             = try(browser_step.value.params.delay, null)
        element           = try(browser_step.value.params.element, null)
        email             = try(browser_step.value.params.email, null)
        file              = try(browser_step.value.params.file, null)
        files             = try(browser_step.value.params.files, null)
        modifiers         = try(browser_step.value.params.modifiers, null)
        playing_tab_id    = try(browser_step.value.params.playing_tab_id, null)
        request           = try(browser_step.value.params.request, null)
        subtest_public_id = try(browser_step.value.params.subtest_public_id, null)
        value             = try(browser_step.value.params.value, null)
        with_click        = try(browser_step.value.params.with_click, null)
        x                 = try(browser_step.value.params.x, null)
        y                 = try(browser_step.value.params.y, null)

        dynamic "variable" {
          for_each = lookup(browser_step.value.params, "variable", null) != null ? [1] : []

          content {
            example = try(browser_step.value.params.variable.example, null)
            name    = try(browser_step.value.params.variable.name, null)
          }
        }
      }
    }
  }

  dynamic "browser_variable" {
    for_each = try(each.value.browser_variable, [])

    content {
      name    = browser_variable.value.name
      type    = browser_variable.value.type
      example = lookup(browser_variable.value, "example", null)
      id      = lookup(browser_variable.value, "id", null)
      pattern = lookup(browser_variable.value, "pattern", null)
    }
  }

  dynamic "config_variable" {
    for_each = try(each.value.config_variable, [])

    content {
      name    = config_variable.value.name
      type    = config_variable.value.type
      example = lookup(config_variable.value, "example", null)
      id      = lookup(config_variable.value, "id", null)
      pattern = lookup(config_variable.value, "pattern", null)
    }
  }

}
