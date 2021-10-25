locals {
  enabled = module.this.enabled

  datadog_monitor_slos = { for slo in var.datadog_slos : slo.name => slo if slo.type == "monitor" && local.enabled }
  datadog_metric_slos  = { for slo in var.datadog_slos : slo.name => slo if slo.type == "metric" && local.enabled }
  #  datadog_slos         = { for slo in var.datadog_slos : slo.name => slo if local.enabled }
  datadog_slo_metric_monitors = flatten([
    for slo in var.datadog_slos : [
      for threshold in slo.thresholds : {
        slo = slo,
        threshold = threshold
      }
      if slo.type == "metric" && local.enabled
    ]
  ])

#  {
#  for slo in var.datadog_slos : [
#    for theshold in slo.thresholds :
#
#  ]
#    slo.name => slo if slo.type == "metric" && local.enabled
#  }
  alert_tags = local.enabled && var.alert_tags != null ? format("%s%s", var.alert_tags_separator, join(var.alert_tags_separator, var.alert_tags)) : ""

}


resource "datadog_service_level_objective" "monitor_slo" {
  for_each = local.datadog_monitor_slos

  #  Required
  name = each.value.name
  type = each.value.type

  dynamic "thresholds" {
    for_each = each.value.thresholds
    content {
      target    = lookup(thresholds, "target", "99.00")
      timeframe = lookup(thresholds, "timeframe", "7d")

      target_display  = lookup(thresholds, "target_display", "98.00")
      warning         = lookup(thresholds, "warning", "99.95")
      warning_display = lookup(thresholds, "warning_display", "98.00")
    }
  }

  groups      = lookup(each.value, "groups", [])
  monitor_ids = each.value.monitor_ids

  #  Optional
  description  = lookup(each.value, "description", null)
  force_delete = lookup(each.value, "force_delete", true)
  validate     = lookup(each.value, "validate", false)


  tags = lookup(each.value, "tags", module.this.tags)
}

resource "datadog_service_level_objective" "metric_slo" {
  for_each = local.datadog_metric_slos

  #  Required
  name = each.value.name
  type = each.value.type

  query {
    denominator = each.value.query.denominator
    numerator   = each.value.query.numerator
  }

  #  Optional
  description  = lookup(each.value, "description", null)
  force_delete = lookup(each.value, "force_delete", true)
  validate     = lookup(each.value, "validate", false)

  dynamic "thresholds" {
    for_each = each.value.thresholds
    content {
      target    = lookup(thresholds, "target", "99.00")
      timeframe = lookup(thresholds, "timeframe", "7d")

      target_display  = lookup(thresholds, "target_display", "97.00")
      warning         = lookup(thresholds, "warning", "99.95")
      warning_display = lookup(thresholds, "warning_display", "98.00")
    }
  }

  tags = lookup(each.value, "tags", module.this.tags)
}

#resource "datadog_monitor" "" {
#  message = ""
#  name = ""
#  query = ""
#  type = ""
#}

#resource "datadog_monitor" "metric-based-slo" {
#name = "SLO Error Budget Alert Example"
#type  = "slo alert"
#
#query = <<EOT
#    error_budget("slo_id").over("time_window") > 75
#    EOT
#
#message = "Example monitor message"
#monitor_thresholds = {
#  critical = 75
#}
#tags = ["foo:bar", "baz"]
#}
// this one
resource "datadog_monitor" "metric_slo_alert" {
  for_each = local.datadog_slo_metric_monitors

  name    = format("(SLO Error Budget Alert) %s", each.value.slo.name)
  type    = "slo alert"
  message = format("%s%s", each.value.message, local.alert_tags)
  query   = format("error_budget(%s).over(%s) > %s", datadog_service_level_objective.metric_slo[each.key].id, each.value.threshold.timeframe, lookup(each.value.threshold, "target", "99.00"))

  monitor_thresholds {
      critical = lookup(each.value., "target", null)
  }

  tags = lookup(each.value, "tags", module.this.tags)

}
#module "datadog_monitor" {
#  source = "../monitors"
#
#  for_each = var.datadog_slos
#  dynamic "datadog_monitors" {
#
#  }
#  datadog_monitors = {
#    name                = format("%s%s", "(SLO Error Budget Alert) ", each.value.name)
#    type                = "slo alert"
#    query               = "error_budget("slo_id").over("time_window") > 75"
#    message             = "The I/O wait time for ({{host.name}} {{host.ip}}) is very high"
#    escalation_message  = ""
#    tags                = ["ManagedBy:Terraform"]
#    notify_no_data      = false
#    notify_audit        = true
#    require_full_window = true
#    enable_logs_sample  = false
#    force_delete        = true
#    include_tags        = true
#    locked              = false
#    renotify_interval   = 60
#    timeout_h           = 60
#    evaluation_delay    = 60
#    new_host_delay      = 300
#    no_data_timeframe   = 10
#    threshold_windows   = {}
#    thresholds          = 30
#    critical            = 50
#    warning             = 30
#    #unknown=
#    #ok=
#    #critical_recovery=
#    #warning_recovery=
#  }
#}
