locals {
  alert_tags = module.this.enabled && var.alert_tags != null ? format("%s%s", var.alert_tags_separator, join(var.alert_tags_separator, var.alert_tags)) : ""

  formatted_tags = [
    for tag_name, tag_val in module.this.tags :
    "${tag_name}:${tag_val}"
  ]
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

  tags = concat(lookup(each.value, "tags", null), local.formatted_tags)
}
