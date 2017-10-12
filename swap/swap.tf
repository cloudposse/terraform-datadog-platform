resource "datadog_monitor" "swap_free" {
  count = "${var.monitor_enabled ? 1 : 0}"
  name  = "Insufficient of free swap space ${module.label.id}"
  type  = "${var.alert_type}"

  message = <<EOF
  Insufficient of free swap space  ${var.period} on host {host.name} ({host.ip})
  ${var.remediation}
  ${var.notify}
  EOF

  escalation_message = "Insufficient of free swap space  on host {host.name} ({host.ip}) hasn't been solved ${var.escalation_notify}"
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
