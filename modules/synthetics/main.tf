# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/synthetics_test

locals {
  enabled    = module.this.enabled
  alert_tags = local.enabled && var.alert_tags != null ? format("%s%s", var.alert_tags_separator, join(var.alert_tags_separator, var.alert_tags)) : ""

  all_public_locations = sort(keys({ for k, v in data.datadog_synthetics_locations.public_locations.locations : k => v if length(regexall(".*pl:.*", k)) == 0 }))

  tests = var.datadog_synthetics
}

data "datadog_synthetics_locations" "public_locations" {}

# datadog_synthetics_test is a huge resource. To ease maintenance,
# PLEASE KEEP THE ELEMENTS IN THE SAME ORDER as in the Terraform documentation,
# which is required elements in alphabetical order, then optional elements in alphabetical order.
#
# We accept parameters with the name specified in the [Terraform documentation](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/synthetics_test),
# or the name returned by the Datadog API, either [API Tests](https://docs.datadoghq.com/api/latest/synthetics/#get-an-api-test)
# or [browser tests](https://docs.datadoghq.com/api/latest/synthetics/#get-a-browser-test). Note that at this time,
# the Datadog documentation for the data returned by the [Get all synthetic tests](https://docs.datadoghq.com/api/latest/synthetics/#get-the-list-of-all-synthetic-tests)
# is incomplete and does not include fields unique to API or browser tests, but the API does in fact return them.
resource "datadog_synthetics_test" "default" {
  for_each = { for k, v in local.tests : k => v if local.enabled && lookup(v, "enabled", true) }

  # Required
  locations = distinct([for loc in concat(concat(lookup(each.value, "locations", []), var.locations), contains(split(",", lower(join(",", concat(lookup(each.value, "locations", []), var.locations)))), "all") ? local.all_public_locations : []) : loc
    if loc != "all"
  ])

  name   = each.value.name
  status = each.value.status
  type   = each.value.type

  # Optional

  ######## Beginning of API step ########
  # API step is huge, and has many of the same inputs as the top-level resource,
  # so be careful when making changes that you are making them in the right place.
  dynamic "api_step" {
    # This is the general pattern for supporting 2 styles of inputs:
    # We first look up the value using the Terraform schema, then we try to look it up using the API schema.
    for_each = lookup(each.value, "api_step", try(each.value.config.steps, []))

    content {
      # Required
      name = api_step.value.name

      # Optional
      allow_failure = lookup(api_step.value, "allow_failure", lookup(api_step.value, "allowFailure", null))

      # API step assertion, for a single step in a multi-step API test. Distinct from top-level test assertions.
      dynamic "assertion" {
        for_each = lookup(api_step.value, "assertion", lookup(api_step.value, "assertions", []))

        content {
          operator = assertion.value.operator
          type     = assertion.value.type
          property = lookup(assertion.value, "property", null)
          target   = try(tostring(assertion.value.target), null)

          dynamic "targetjsonpath" {
            for_each = assertion.value.operator == "validatesJSONPath" ? [lookup(assertion.value, "targetjsonpath", lookup(assertion.value, "target", null))] : []

            content {
              jsonpath         = lookup(targetjsonpath.value, "jsonpath", lookup(targetjsonpath.value, "jsonPath", null))
              elementsoperator = lookup(targetjsonpath.value, "elementsoperator", lookup(targetjsonpath.value, "elementsOperator", null))
              operator         = targetjsonpath.value.operator
              targetvalue      = lookup(targetjsonpath.value, "targetvalue", lookup(targetjsonpath.value, "targetValue", null))
            }
          }

          dynamic "targetxpath" {
            for_each = assertion.value.operator == "validatesXPath" ? [lookup(assertion.value, "targetxpath", lookup(assertion.value, "target", null))] : []

            content {
              operator    = targetxpath.value.operator
              xpath       = lookup(targetxpath.value, "xpath", lookup(targetxpath.value, "xPath", null))
              targetvalue = lookup(targetxpath.value, "targetvalue", lookup(targetxpath.value, "targetValue", null))
            }
          }
        }
      }

      dynamic "extracted_value" {
        for_each = lookup(api_step.value, "extracted_value", lookup(api_step.value, "extractedValues", []))

        content {
          name = extracted_value.value.name

          parser {
            type  = extracted_value.value.parser.type
            value = lookup(extracted_value.value.parser, "value", null)
          }
          type   = extracted_value.value.type
          field  = lookup(extracted_value.value, "field", null)
          secure = lookup(extracted_value.value, "secure", null)
        }
      }

      is_critical = lookup(api_step.value, "is_critical", lookup(api_step.value, "isCritical", null))
      # request_basicauth is insecure and complex, so we do not support it at this time.

      dynamic "request_client_certificate" {
        for_each = [for v in [lookup(api_step.value, "request_client_certificate", try(api_step.value.request.certificate, null))] : v if v != null]

        content {
          cert {
            content  = request_client_certificate.value.cert.content
            filename = lookup(request_client_certificate.value.cert, "filename", null)
          }

          key {
            content  = request_client_certificate.value.key.content
            filename = lookup(request_client_certificate.value.key, "filename", null)
          }
        }
      }

      # Exactly 1 request definition inside an API step is required, but we make it dynamic
      # to support the 2 styles of inputs and simplify the value reference.
      dynamic "request_definition" {
        for_each = [for v in [lookup(api_step.value, "request_definition", lookup(api_step.value, "request", null))] : v if v != null]
        iterator = req

        content {
          # [sic] The API breaks its camelCase convention for "allow_insecure".
          allow_insecure = lookup(req.value, "allow_insecure", null)
          # We are not supporting BasicAuth. If we were, it would be above in a `request_basicauth` block
          body      = lookup(req.value, "body", null)
          body_type = lookup(req.value, "body_type", lookup(req.value, "bodyType", null))
          call_type = lookup(req.value, "call_type", lookup(req.value, "callType", null))
          # certificate handled in a separate `request_client_certificate` block above
          certificate_domains = lookup(req.value, "certificate_domains", lookup(req.value, "certificateDomains", []))
          dns_server          = lookup(req.value, "dns_server", lookup(req.value, "dnsServer", null))
          dns_server_port     = lookup(req.value, "dns_server_port", lookup(req.value, "dnsServerPort", null))
          # [sic] The API breaks its camelCase convention for "follow_redirects".
          follow_redirects = lookup(req.value, "follow_redirects", null)
          # headers is in a separate `request_headers` block below
          host = lookup(req.value, "host", null)
          # httpVersion input is missing from all documentation, but seen in API output
          http_version = lookup(req.value, "http_version", null)
          message = lookup(req.value, "message", null)
          # metadata input is missing.
          # See https://github.com/DataDog/terraform-provider-datadog/issues/2155
          method                  = lookup(req.value, "method", null)
          no_saving_response_body = lookup(req.value, "no_saving_response_body", lookup(req.value, "noSavingResponseBody", null))
          number_of_packets       = lookup(req.value, "number_of_packets", lookup(req.value, "numberOfPackets", null))
          persist_cookies         = lookup(req.value, "persist_cookies", lookup(req.value, "persistCookies", null))
          port                    = lookup(req.value, "port", null)
          proto_json_descriptor   = lookup(req.value, "proto_json_descriptor", lookup(req.value, "compressedJsonDescriptor", null))

          # proxy handled in a separate `request_proxy` block below
          # query handled in a separate `request_query` block below

          servername        = lookup(req.value, "servername", null)
          service           = lookup(req.value, "service", null)
          should_track_hops = lookup(req.value, "should_track_hops", lookup(req.value, "shouldTrackHops", null))
          timeout           = lookup(req.value, "timeout", null)
          url               = lookup(req.value, "url", null)
        }
      }

      request_headers = lookup(api_step.value, "request_headers", try(api_step.value.request.headers, null))

      dynamic "request_proxy" {
        for_each = [for v in [lookup(api_step.value, "request_proxy", try(api_step.value.request.proxy, null))] : v if v != null]

        content {
          url     = request_proxy.value.url
          headers = lookup(request_proxy.value, "username", null)
        }
      }

      request_query = lookup(api_step.value, "request_query", try(api_step.value.request.query, null))

      dynamic "retry" {
        for_each = [for v in [lookup(api_step.value, "retry", null)] : v if v != null]

        content {
          count    = lookup(retry.value, "count", null)
          interval = lookup(retry.value, "interval", null)
        }
      }

      subtype = lookup(api_step.value, "subtype", false)
    }
  }
  ########### End of API step ###########

  # Assertions for the entire test, distinct from assertions for a single step in a multi-step API test.
  dynamic "assertion" {
    for_each = lookup(each.value, "assertion", try(each.value.config.assertions, []))
    content {
      operator = assertion.value.operator
      type     = assertion.value.type
      property = lookup(assertion.value, "property", null)
      target   = try(tostring(assertion.value.target), null)

      dynamic "targetjsonpath" {
        for_each = assertion.value.operator == "validatesJSONPath" ? [lookup(assertion.value, "targetjsonpath", lookup(assertion.value, "target", null))] : []

        content {
          jsonpath         = lookup(targetjsonpath.value, "jsonpath", lookup(targetjsonpath.value, "jsonPath", null))
          elementsoperator = lookup(targetjsonpath.value, "elementsoperator", lookup(targetjsonpath.value, "elementsOperator", null))
          operator         = targetjsonpath.value.operator
          targetvalue      = lookup(targetjsonpath.value, "targetvalue", lookup(targetjsonpath.value, "targetValue", null))
        }
      }

      dynamic "targetxpath" {
        for_each = assertion.value.operator == "validatesXPath" ? [lookup(assertion.value, "targetxpath", lookup(assertion.value, "target", null))] : []

        content {
          operator    = targetxpath.value.operator
          xpath       = lookup(targetxpath.value, "xpath", lookup(targetxpath.value, "xPath", null))
          targetvalue = lookup(targetxpath.value, "targetvalue", lookup(targetxpath.value, "targetValue", null))
        }
      }

      timings_scope = lookup(assertion.value, "timings_scope", lookup(assertion.value, "timingsScope", null))
    }
  }
  ##### End of assertions for the entire test #####

  dynamic "browser_step" {
    for_each = lookup(each.value, "browser_step", lookup(each.value, "steps", []))
    iterator = step

    content {
      # Required
      name = step.value.name

      params {
        attribute  = lookup(step.value.params, "attribute", null)
        check      = lookup(step.value.params, "check", null)
        click_type = lookup(step.value.params, "click_type", lookup(step.value.params, "clickType", null))
        code       = lookup(step.value.params, "code", null)
        delay      = lookup(step.value.params, "delay", null)
        # element is a JSON encoded string in the Terraform schema, but a complex object in the API schema.
        element = try(
          # If it is present and a string, assume it is JSON encoded and pass it through.
          # If it is absent, pass `{}` to `tostring()` to cause it to fail and return null in the next step.
          tostring(lookup(step.value.params, "element", {})),
          # Otherwise, try to convert it to JSON. This should only fail if the value is not present,
          # in which case we pass null.
          try(jsonencode(step.value.params.element), null)
        )

        # Even though the `element_user_locator` input duplicates the `userLocator` field in the JSON encoded `element` input,
        # it causes drift it if is not explicitly set in the `element_user_locator` block, so we extract it and set it here.

        dynamic "element_user_locator" {
          for_each = [for v in [lookup(step.value.params, "element_user_locator", try(step.value.params.element.userLocator, null))] : v if v != null]

          content {
            # Although userLocator.values is a list in the API output, it is undocumented in the API schema,
            # and only a single value is allowed according to the Terraform documentation.
            # Since it is a single rule for locating a single HTML element, it makes sense that only one is allowed.
            # Therefore we only use the first item in the `values` list from the API schema.
            # In the terraform schema, we do not allow a list.
            value {
              value = try(element_user_locator.value.value, try(element_user_locator.value.values[0].value), null)
              type  = try(element_user_locator.value.type, try(element_user_locator.value.values[0].type, null))
            }

            fail_test_on_cannot_locate = lookup(element_user_locator.value, "fail_test_on_cannot_locate", lookup(element_user_locator.value, "failTestOnCannotLocate", null))
          }
        }

        email             = lookup(step.value.params, "email", null)
        file              = lookup(step.value.params, "file", null)
        files             = lookup(step.value.params, "files", null)
        modifiers         = lookup(step.value.params, "modifiers", [])
        playing_tab_id    = lookup(step.value.params, "playing_tab_id", lookup(step.value.params, "playingTabId", null))
        request           = lookup(step.value.params, "request", null)
        subtest_public_id = lookup(step.value.params, "subtest_public_id", lookup(step.value.params, "subtestPublicId", null))
        value             = lookup(step.value.params, "value", null)

        dynamic "variable" {
          for_each = [for v in [lookup(step.value.params, "variable", null)] : v if v != null]

          content {
            example = lookup(variable.value, "example", null)
            name    = lookup(variable.value, "name", null)
          }
        }

        with_click = lookup(step.value.params, "with_click", lookup(step.value.params, "withClick", null))
        x          = lookup(step.value.params, "x", null)
        y          = lookup(step.value.params, "y", null)
      } # End of browser_step.params

      type = step.value.type

      # Optional
      allow_failure        = lookup(step.value, "allow_failure", lookup(step.value, "allowFailure", null))
      force_element_update = lookup(step.value, "force_element_update", lookup(step.value, "forceElementUpdate", null))
      is_critical          = lookup(step.value, "is_critical", lookup(step.value, "isCritical", null))
      no_screenshot        = lookup(step.value, "no_screenshot", lookup(step.value, "noScreenshot", null))
      # As of Datadog provider 3.30.0, supplying null for `timeout` causes drift.
      # The provider substitutes the default value of 60 seconds, but the API
      # returns 0 to indicate the default setting.
      timeout = lookup(step.value, "timeout", 0)
    }
  }
  ####### End of browser_step #######

  dynamic "browser_variable" {
    for_each = lookup(each.value, "browser_variable", try(each.value.config.variables, []))

    content {
      name    = browser_variable.value.name
      type    = browser_variable.value.type
      example = lookup(browser_variable.value, "example", null)
      id      = lookup(browser_variable.value, "id", null)
      pattern = lookup(browser_variable.value, "pattern", null)
      secure  = lookup(browser_variable.value, "secure", null)
    }
  }

  dynamic "config_variable" {
    for_each = lookup(each.value, "config_variable", try(each.value.config.configVariables, []))

    content {
      name    = config_variable.value.name
      type    = config_variable.value.type
      example = lookup(config_variable.value, "example", null)
      id      = lookup(config_variable.value, "id", null)
      pattern = lookup(config_variable.value, "pattern", null)
      secure  = lookup(config_variable.value, "secure", null)
    }
  }

  # The API breaks its camelCase convention for "device_ids", but it is nested under options.
  device_ids = lookup(each.value, "device_ids", try(each.value.options.device_ids, []))
  message    = lookup(each.value, "message", null) != null ? format("%s%s", each.value.message, local.alert_tags) : null

  dynamic "options_list" {
    for_each = [for v in [lookup(each.value, "options_list", lookup(each.value, "options", null))] : v if v != null]
    iterator = opts

    content {
      # Required
      tick_every = opts.value.tick_every

      # Optional
      # Many of the options are snake_case in the API as well as Terraform
      accept_self_signed           = lookup(opts.value, "accept_self_signed", null)
      allow_insecure               = lookup(opts.value, "allow_insecure", null)
      check_certificate_revocation = lookup(opts.value, "check_certificate_revocation", lookup(opts.value, "checkCertificateRevocation", null))

      dynamic "ci" {
        for_each = [for v in [lookup(opts.value, "ci", null)] : v if v != null]

        content {
          execution_rule = lookup(ci.value, "execution_rule", lookup(ci.value, "executionRule", null))
        }
      }

      disable_cors                    = lookup(opts.value, "disable_cors", lookup(opts.value, "disableCors", null))
      disable_csp                     = lookup(opts.value, "disable_csp", lookup(opts.value, "disableCsp", null))
      follow_redirects                = lookup(opts.value, "follow_redirects", false)
      http_version                    = lookup(opts.value, "http_version", "http2")
      ignore_server_certificate_error = lookup(opts.value, "ignore_server_certificate_error", lookup(opts.value, "ignoreServerCertificateError", null))
      initial_navigation_timeout      = lookup(opts.value, "initial_navigation_timeout", lookup(opts.value, "initialNavigationTimeout", null))
      min_failure_duration            = lookup(opts.value, "min_failure_duration", null)
      min_location_failed             = lookup(opts.value, "min_location_failed", null)
      monitor_name                    = lookup(opts.value, "monitor_name", null)

      dynamic "monitor_options" {
        for_each = [for v in [lookup(opts.value, "monitor_options", null)] : v if v != null]

        content {
          renotify_interval = monitor_options.value.renotify_interval
        }
      }

      monitor_priority = lookup(opts.value, "monitor_priority", null)
      no_screenshot    = lookup(opts.value, "no_screenshot", lookup(opts.value, "noScreenshot", null))
      restricted_roles = lookup(opts.value, "restricted_roles", [])

      dynamic "retry" {
        for_each = [for v in [lookup(opts.value, "retry", null)] : v if v != null]

        content {
          count    = retry.value.count
          interval = retry.value.interval
        }
      }

      dynamic "rum_settings" {
        for_each = [for v in [lookup(opts.value, "rum_settings", lookup(opts.value, "rumSettings", null))] : v if v != null]

        content {
          # Required
          is_enabled = lookup(rum_settings.value, "is_enabled", lookup(rum_settings.value, "isEnabled", null))
          # Optional
          application_id  = lookup(rum_settings.value, "application_id", lookup(rum_settings.value, "applicationId", null))
          client_token_id = lookup(rum_settings.value, "client_token_id", lookup(rum_settings.value, "clientTokenId", null))
        }
      }

      dynamic "scheduling" {
        for_each = [for v in [lookup(opts.value, "scheduling", null)] : v if v != null]

        content {
          # Required
          timezone = scheduling.value.timezone
          dynamic "timeframes" {
            for_each = lookup(scheduling.value, "timeframes", [])

            content {
              day  = timeframes.value.day
              from = timeframes.value.from
              to   = timeframes.value.to
            }
          }
        }
      }
    }
  }
  ########## End of options_list ##########

  ## request_basicauth is insecure and complex, so we do not support it at this time.

  dynamic "request_client_certificate" {
    for_each = [for v in [lookup(each.value, "request_client_certificate", try(each.value.config.request.certificate, null))] : v if v != null]
    iterator = cert

    content {
      cert {
        content  = cert.value.cert.content
        filename = lookup(cert.value.cert, "filename", null)
      }

      key {
        content  = cert.value.key.content
        filename = lookup(cert.value.key, "filename", null)
      }
    }
  }

  dynamic "request_definition" {
    for_each = [for v in [lookup(each.value, "request_definition", try(each.value.config.request, null))] : v if v != null]
    iterator = req

    content {
      body                = lookup(req.value, "body", null)
      body_type           = lookup(req.value, "body_type", lookup(req.value, "bodyType", null))
      call_type           = lookup(req.value, "call_type", lookup(req.value, "callType", null))
      certificate_domains = lookup(req.value, "certificate_domains", lookup(req.value, "certificateDomains", []))
      dns_server          = lookup(req.value, "dns_server", lookup(req.value, "dnsServer", null))
      dns_server_port     = lookup(req.value, "dns_server_port", lookup(req.value, "dnsServerPort", null))
      # The Terraform schema does not include `follow_redirects` in the `request_definition` block,
      # but it is present in the API schema. It appears to be superseded by the options.follow_redirects input.
      # follow_redirects          = lookup(req.value, "follow_redirects", null)
      # headers is in a separate `request_headers` block below
      host = lookup(req.value, "host", null)
      # httpVersion input is missing from all documentation, but seen in API output.
      http_version = "http2" # options_list isn't respected
      message      = lookup(req.value, "message", null)
      # metadata input is missing.
      # See https://github.com/DataDog/terraform-provider-datadog/issues/2155
      method                  = lookup(req.value, "method", null)
      no_saving_response_body = lookup(req.value, "no_saving_response_body", lookup(req.value, "noSavingResponseBody", null))
      number_of_packets       = lookup(req.value, "number_of_packets", lookup(req.value, "numberOfPackets", null))
      persist_cookies         = lookup(req.value, "persist_cookies", lookup(req.value, "persistCookies", null))
      port                    = lookup(req.value, "port", null)
      proto_json_descriptor   = lookup(req.value, "proto_json_descriptor", lookup(req.value, "compressedJsonDescriptor", null))

      # proxy handled in a separate `request_proxy` block below
      # query handled in a separate `request_query` block below

      servername        = lookup(req.value, "servername", null)
      service           = lookup(req.value, "service", null)
      should_track_hops = lookup(req.value, "should_track_hops", lookup(req.value, "shouldTrackHops", null))
      # To avoid drift, we use a default timeout of zero when there are browser steps.
      timeout = lookup(req.value, "timeout",
        lookup(each.value, "browser_step", lookup(each.value, "steps", null)) == null ? null : 0
      )
      url = lookup(req.value, "url", null)
    }
  }

  request_headers  = lookup(each.value, "request_headers", try(each.value.config.request.headers, {}))
  request_metadata = lookup(each.value, "request_metadata", try(each.value.config.request.metadata, {}))

  dynamic "request_proxy" {
    for_each = [for v in [lookup(each.value, "request_proxy", try(each.value.config.request.proxy, null))] : v if v != null]

    content {
      url     = request_proxy.value.url
      headers = lookup(request_proxy.value, "username", null)
    }
  }

  request_query = lookup(each.value, "request_query", try(each.value.config.request.query, {}))
  set_cookie    = lookup(each.value, "set_cookie", try(each.value.config.setCookie, null))
  subtype       = lookup(each.value, "subtype", null)

  # Convert Terraform tags map to Datadog tags list
  # If a key is supplied with a value:
  #   tags:
  #     key: value
  # it will render the tag as "key:value"
  # If a key is supplied without a value (null)
  #   tags:
  #     key: null
  # it will render the tag as simply "key"
  # However, the API schema takes a list of tags
  #   tags:
  #   - key:value
  # so we just pass those through.
  tags = distinct(compact(concat([
    for tagk, tagv in merge(
      var.default_tags_enabled ? module.this.tags : {},
      # if tags is a map, process it, too
      try(tomap(each.value.tags), {})
    ) : (tagv != null ? format("%s:%s", tagk, tagv) : tagk)
    ],
    # If the user has supplied a list of tags (not a map), pass those through.
    try(tolist(each.value.tags), [])
  )))
}
