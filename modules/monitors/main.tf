locals {
  enabled = module.this.enabled

  alert_tags = local.enabled && var.alert_tags != null ? format("%s%s", var.alert_tags_separator, join(var.alert_tags_separator, var.alert_tags)) : ""
}

# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor
resource "datadog_monitor" "default" {
  for_each = { for k, v in local.datadog_monitors : k => v if local.enabled && lookup(v, "enabled", true) }

  name     = each.value.name
  type     = each.value.type
  query    = each.value.query
  message  = format("%s%s", each.value.message, local.alert_tags)
  priority = try(each.value.priority, null)

  # Assign restricted roles
  # Only these roles will have access to the monitor according to their permissions.
  # If `restricted_roles` is present var map, it takes precedence over the setting in the monitor definition.
  restricted_roles = try(var.restricted_roles_map[each.key], try(each.value.restricted_roles, null))

  # `restricted_roles` conflicts with `locked`, which is deprecated.
  # Use `locked`` only if present and `restricted_roles` is not provided.
  locked = try(var.restricted_roles_map[each.key], try(each.value.restricted_roles, null)) == null ? try(each.value.options.locked, null) : null

  # Setting tags is complicated and moved to the bottom of this resource.

  ##### Attributes under `options` in the API model ####
  enable_logs_sample     = try(each.value.options.enable_logs_sample, null)
  escalation_message     = try(each.value.options.escalation_message, null)
  evaluation_delay       = try(each.value.options.evaluation_delay, null)
  groupby_simple_monitor = try(each.value.options.groupby_simple_monitor, null)
  include_tags           = try(each.value.options.include_tags, null)
  new_group_delay        = try(each.value.options.new_group_delay, null)
  no_data_timeframe      = try(each.value.options.no_data_timeframe, null)
  notify_audit           = try(each.value.options.notify_audit, null)
  notify_no_data         = try(each.value.options.notify_no_data, null)
  renotify_interval      = try(each.value.options.renotify_interval, null)
  renotify_occurrences   = try(each.value.options.renotify_occurrences, null)
  renotify_statuses      = try(each.value.options.renotify_statuses, null)
  require_full_window    = try(each.value.options.require_full_window, null)
  timeout_h              = try(each.value.options.timeout_h, null)

  # DEPRECATED: `new_host_delay` is deprecated, but still needed when set to zero to override default.
  # So it is ignored unless set to zero.
  new_host_delay = try(each.value.options.new_host_delay, null) == 0 ? 0 : null

  dynamic "monitor_thresholds" {
    for_each = try([each.value.options.thresholds], [])
    iterator = thresholds
    content {
      critical          = lookup(thresholds.value, "critical", null)
      critical_recovery = lookup(thresholds.value, "critical_recovery", null)
      ok                = lookup(thresholds.value, "ok", null)
      unknown           = lookup(thresholds.value, "unknown", null)
      warning           = lookup(thresholds.value, "warning", null)
      warning_recovery  = lookup(thresholds.value, "warning_recovery", null)
    }
  }

  dynamic "monitor_threshold_windows" {
    for_each = try([each.value.options.threshold_windows], [])
    iterator = threshold_windows
    content {
      recovery_window = lookup(threshold_windows.value, "recovery_window", null)
      trigger_window  = lookup(threshold_windows.value, "trigger_window", null)
    }
  }

  dynamic "scheduling_options" {
    # Legacy support. In the API, `scheduling_options` is a map of objects, but legacy it was a list of objects.
    for_each = try(tolist(each.value.options.scheduling_options), try([each.value.options.scheduling_options], []))
    content {
      dynamic "custom_schedule" {
        for_each = try([scheduling_options.value.custom_schedule], [])
        content {
          dynamic "recurrence" {
            for_each = try(custom_schedule.value.recurrences, [])
            content {
              rrule    = recurrence.value.rrule
              timezone = recurrence.value.timezone
              start    = try(recurrence.value.start, null)
            }
          } # recurrence
        }
      } # custom_schedule

      dynamic "evaluation_window" {
        # Legacy support. In the API, `evaluation_window` is a map of objects, but legacy it was a list of objects.
        for_each = try(tolist(scheduling_options.value.evaluation_window), try([scheduling_options.value.evaluation_window], []))
        content {
          day_starts   = lookup(evaluation_window.value, "day_starts", null)
          hour_starts  = lookup(evaluation_window.value, "hour_starts", null)
          month_starts = lookup(evaluation_window.value, "month_starts", null)
        }
      } # evaluation_window
    }
  } # scheduling_options

  dynamic "variables" {
    # There is only one `variables` block in the Terraform model.
    for_each = try(length(tolist(each.value.options.variables)), 0) > 0 ? ["variables"] : []
    content {
      # The JSON `variables` attribute is a list of objects,
      # but in Terraform the list is expressed as repeated `event_query` blocks under `variables`.
      dynamic "event_query" {
        for_each = each.value.options.variables
        iterator = query
        content {
          compute {
            aggregation = query.value.compute.aggregation
            interval    = lookup(query.value.compute, "interval", null)
            metric      = lookup(query.value.compute, "metric", null)
          }

          data_source = query.value.data_source

          dynamic "group_by" {
            for_each = try(query.value.group_by, [])
            content {
              facet = group_by.value.facet
              limit = try(group_by.value.limit, null)

              dynamic "sort" {
                for_each = try([group_by.value.sort], [])
                content {
                  aggregation = sort.value.aggregation
                  metric      = try(sort.value.metric, null)
                  order       = try(sort.value.order, null)
                }
              } # sort
            }
          } # group_by

          indexes = try(query.value.indexes, null)
          name    = query.value.name

          search {
            # Cannot be null or empty string, use "*" which is equivalent to "" and matches everything
            # See https://github.com/DataDog/terraform-provider-datadog/pull/2275
            query = coalesce(try(query.value.search.query, null), "*")
          }
        }
      } # event_query
    }
  } # variables

  ###  End of `options` attributes ###

  # `force_delete` and `validate` are not part of the Datadog API monitor model.
  # They are features provided by the Datadog Terraform provider to help manage the monitors.
  force_delete = lookup(each.value, "force_delete", null)
  # If validate is set to false, Terraform will skip the validation call done during plan.
  validate = lookup(each.value, "validate", null)

  ############################
  # TAGS
  ############################
  # Datadog's tags are a list of strings, but Terraform's tags are a map of strings.
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
  # so if the tags are provided as a list, we just pass that through.
  # If the monitor has no setting for tags, we add the default tags, if enabled.
  tags = try(tolist(each.value.tags), null) != null ? try(tolist(each.value.tags), null) : [
    # If the user has supplied a map of tags, use it. Otherwise, use the default tags if enabled.
    for tagk, tagv in try(tomap(each.value.tags), var.default_tags_enabled ? module.this.tags : {}) : (tagv != null ? format("%s:%s", tagk, tagv) : tagk)
  ]
}
