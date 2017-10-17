resource "datadog_monitor" "cpu_average" {
  count = "${var.monitor_enabled ? 1 : 0}"
  name  = "High CPU usage ${module.label.id}"
  type  = "${var.alert_type}"

  message = <<EOF
  High CPU usage for last ${var.period} on host {host.name} ({host.ip})
  ${var.remediation}
  ${var.notify}
  EOF

  escalation_message = "High CPU usage for last ${var.period} on host {host.name} ({host.ip}) hasn't been solved ${var.escalation_notify}"
  query              = "avg(last_${var.period}):avg:system.cpu.system{${join(",", compact(var.selector))}} by ${var.group_by} > ${var.critical_threshold}"

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

resource "datadog_monitor" "cpu_iowait" {
  count = "${var.monitor_enabled ? 1 : 0}"
  name  = "High CPU iowait ${module.label.id}"
  type  = "${var.alert_type}"

  message = <<EOF
  High CPU iowait for last ${var.period} on host {host.name} ({host.ip})
  ${var.remediation}
  ${var.notify}
  EOF

  escalation_message = "High CPU iowait for last ${var.period} on host {host.name} ({host.ip}) hasn't been solved ${var.escalation_notify}"
  query              = "avg(last_${var.period}):avg:system.cpu.iowait{${join(",", compact(var.selector))}} by ${var.group_by} > ${var.critical_threshold}"

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
