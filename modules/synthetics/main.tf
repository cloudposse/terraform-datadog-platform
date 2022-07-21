# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/synthetics_test

locals {
  enabled    = module.this.enabled
  alert_tags = local.enabled && var.alert_tags != null ? format("%s%s", var.alert_tags_separator, join(var.alert_tags_separator, var.alert_tags)) : ""

  all_public_locations = sort(keys({ for k, v in data.datadog_synthetics_locations.public_locations.locations : k => v if ! (length(regexall(".*pl:.*", k)) > 0) }))
}

data "datadog_synthetics_locations" "public_locations" {}


resource "datadog_synthetics_test" "default" {
  for_each = { for k, v in var.datadog_synthetics : k => v if local.enabled && lookup(v, "enabled", true) }

  # Required
  name   = each.value.name
  type   = each.value.type
  status = each.value.status

  locations = distinct([for loc in concat(concat(try(each.value.locations, []), var.locations), contains(split(",", lower(join(",", concat(try(each.value.locations, []), var.locations)))), "all") ? local.all_public_locations : []) : loc
    if loc != "all"
  ])

  # Optional
  message = lookup(each.value, "message", null) != null ? format("%s%s", each.value.message, local.alert_tags) : null
  subtype = lookup(each.value, "subtype", null)

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

  request_headers = lookup(each.value, "request_headers", null)
  request_query   = lookup(each.value, "request_query", null)
  set_cookie      = lookup(each.value, "set_cookie", null)
  device_ids      = lookup(each.value, "device_ids", null)

  dynamic "assertion" {
    for_each = try(each.value.assertion, [])

    content {
      type     = assertion.value.type
      operator = assertion.value.operator
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
      tick_every           = each.value.options_list.tick_every
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
          type     = assertion.value.type
          operator = assertion.value.operator
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
          name  = extracted_value.value.name
          type  = extracted_value.value.type
          field = lookup(extracted_value.value, "field", null)

          parser {
            type  = extracted_value.value.parser.type
            value = lookup(extracted_value.value.parser, "value", null)
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
          cert {
            content  = api_step.value.request_client_certificate.cert.content
            filename = lookup(api_step.value.request_client_certificate.cert, "filename", null)
          }

          key {
            content  = api_step.value.request_client_certificate.key.content
            filename = lookup(api_step.value.request_client_certificate.key, "filename", null)
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
        attribute         = lookup(browser_step.value.params, "attribute", null)
        check             = lookup(browser_step.value.params, "check", null)
        click_type        = lookup(browser_step.value.params, "click_type", null)
        code              = lookup(browser_step.value.params, "code", null)
        delay             = lookup(browser_step.value.params, "delay", null)
        element           = lookup(browser_step.value.params, "element", null)
        email             = lookup(browser_step.value.params, "email", null)
        file              = lookup(browser_step.value.params, "file", null)
        files             = lookup(browser_step.value.params, "files", null)
        modifiers         = lookup(browser_step.value.params, "modifiers", null)
        playing_tab_id    = lookup(browser_step.value.params, "playing_tab_id", null)
        request           = lookup(browser_step.value.params, "request", null)
        subtest_public_id = lookup(browser_step.value.params, "subtest_public_id", null)
        value             = lookup(browser_step.value.params, "value", null)
        with_click        = lookup(browser_step.value.params, "with_click", null)
        x                 = lookup(browser_step.value.params, "x", null)
        y                 = lookup(browser_step.value.params, "y", null)

        dynamic "variable" {
          for_each = lookup(browser_step.value.params, "variable", null) != null ? [1] : []

          content {
            example = lookup(browser_step.value.params.variable, "example", null)
            name    = lookup(browser_step.value.params.variable, "name", null)
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

  dynamic "request_basicauth" {
    for_each = lookup(each.value, "request_basicauth", null) != null ? [1] : []

    content {
      password = each.value.request_basicauth.password
      username = each.value.request_basicauth.username
    }
  }

  dynamic "request_client_certificate" {
    for_each = lookup(each.value, "request_client_certificate", null) != null ? [1] : []

    content {
      cert {
        content  = each.value.request_client_certificate.cert.content
        filename = lookup(each.value.request_client_certificate.cert, "filename", null)
      }

      key {
        content  = each.value.request_client_certificate.key.content
        filename = lookup(each.value.request_client_certificate.key, "filename", null)
      }
    }
  }
}
