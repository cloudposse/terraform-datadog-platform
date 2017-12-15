resource "datadog_monitor" "swap_space" {
  count = "${var.monitor_enabled == "true" ? 1 : 0}"
  name  = "[${module.label.id}] swap space"
  type  = "${var.alert_type}"

  message = <<EOF
  Swap space for last ${var.period} on host {host.name} ({host.ip})
  ${var.remediation}
  ${var.notify}
  EOF

  escalation_message = "Swap space on host {host.name} ({host.ip}) ${var.escalation_notify}"
  query              = "avg(last_${var.period}):avg:system.swap.free{${join(",", compact(var.selector))}} by ${var.group_by} > ${var.critical_threshold}"

  thresholds {
    ok       = "${var.ok_threshold}"
    warning  = "${var.warning_threshold}"
    critical = "${var.critical_threshold}"
  }

  renotify_interval = "${var.renotify_interval}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = "${var.datadog_monitor_tags}"
}
