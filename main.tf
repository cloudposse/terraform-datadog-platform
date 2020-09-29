locals {
  datadog_monitors = module.this.enabled ? merge([
    for ruleset in yamldecode(file(var.monitors_config_file)).rulesets : {
      for k, v in ruleset.monitors :
      "${ruleset.name}-${k}" => merge(v, { "ruleset" : ruleset.name })
    }
  ]...) : {}
}

# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor
resource "datadog_monitor" "default" {
  for_each = module.this.enabled && var.monitors_enabled ? local.datadog_monitors : {}

  name               = format("[%s] %s", each.value.ruleset, each.value.name)
  type               = each.value.type
  message            = "${each.value.message}${var.alert_tags != null && var.alert_tags != "" ? var.alert_tags : ""}"
  escalation_message = lookup(each.value, "escalation_message", null)

  query = each.value.query

  thresholds = {
    ok                = lookup(each.value.options.thresholds, "ok", null)
    warning           = lookup(each.value.options.thresholds, "warning", null)
    warning_recovery  = lookup(each.value.options.thresholds, "warning_recovery", null)
    critical          = lookup(each.value.options.thresholds, "critical", null)
    critical_recovery = lookup(each.value.options.thresholds, "critical_recovery", null)
    unknown           = lookup(each.value.options.thresholds, "unknown", null)
  }

  require_full_window = lookup(each.value.options, "require_full_window", null)
  notify_no_data      = lookup(each.value.options, "notify_no_data", null)
  renotify_interval   = lookup(each.value.options, "renotify_interval", null)

  notify_audit = lookup(each.value.options, "notify_audit", null)
  timeout_h    = lookup(each.value.options, "timeout_h", null)
  include_tags = lookup(each.value.options, "include_tags", null)

  tags = var.monitor_tags
}
