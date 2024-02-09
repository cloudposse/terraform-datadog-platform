# Legacy support
#
# The preferred way to use this module is to supply configuration matching the
# model of the Datadog API. However, the module also supports a legacy mode
# where the configuration that is in the model under `options` can be provided
# at the top level of the map. This mode is deprecated and will not be enhanced
# to include new features, e.g. `group_retention_duration` or
# `scheduling_options.custom_schedule`.
#

locals {
  # Step one, list all the keys that are in the legacy configuration
  # that should be under options. Only the keys that were in the legacy
  # module are listed here. New keys should not be added to this list.
  # Instead, users should convert their configuration to the new model.
  legacy_attributes = [
    "enable_logs_sample",
    "escalation_message",
    "evaluation_delay",
    "groupby_simple_monitor",
    "include_tags",
    "locked",
    "new_group_delay",
    "new_host_delay",
    "no_data_timeframe",
    "notify_audit",
    "notify_no_data",
    "priority",
    "renotify_interval",
    "renotify_occurrences",
    "renotify_statuses",
    "require_full_window",
    "scheduling_options",
    "thresholds",
    "threshold_windows",
    "timeout_h",
    "validate"
  ]

  # Step two, create a map containing the legacy options that should be moved.
  # We do not need to remove the keys from the original map, as they will simply be ignored.
  legacy_option_attributes_maps = { for k, v in var.datadog_monitors : k => { for attr in local.legacy_attributes : attr => v[attr] if try(v[attr], null) != null } }

  # Step three, add the legacy options to the maps under the `options` key,
  # but only if the `options` key is not already present.
  datadog_monitors = { for k, v in var.datadog_monitors : k => merge(
    { options = local.legacy_option_attributes_maps[k] }, v)
  }
}
