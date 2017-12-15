resource "datadog_monitor" "load_average_1" {
  count = "${var.monitor_enabled == "true" ? 1 : 0}"
  name  = "[${module.label.id}] 1m load average"
  type  = "${var.alert_type}"

  message = <<EOF
  1m load average for last ${var.period} on host {host.name} ({host.ip})
  ${var.remediation}
  ${var.notify}
  EOF

  escalation_message = "1m load average for last ${var.period} on host {host.name} ({host.ip}) ${var.escalation_notify}"
  query              = "avg(last_${var.period}):avg:system.load.1{${join(",", compact(var.selector))}} by ${var.group_by} > ${var.critical_threshold}"

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

resource "datadog_monitor" "load_average_5" {
  count = "${var.monitor_enabled == "true" ? 1 : 0}"
  name  = "[${module.label.id}] 5m load average"
  type  = "${var.alert_type}"

  message = <<EOF
  5m load average for last ${var.period} on host {host.name} ({host.ip})
  ${var.remediation}
  ${var.notify}
  EOF

  escalation_message = "5m load average for last ${var.period} on host {host.name} ({host.ip}) ${var.escalation_notify}"
  query              = "avg(last_${var.period}):avg:system.load.5{${join(",", compact(var.selector))}} by ${var.group_by} > ${var.critical_threshold}"

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

resource "datadog_monitor" "load_average_15" {
  count = "${var.monitor_enabled == "true" ? 1 : 0}"
  name  = "[${module.label.id}] 15m load average"
  type  = "${var.alert_type}"

  message = <<EOF
  15m load average for last ${var.period} on host {host.name} ({host.ip})
  ${var.remediation}
  ${var.notify}
  EOF

  escalation_message = "15m load average for last ${var.period} on host {host.name} ({host.ip}) ${var.escalation_notify}"
  query              = "avg(last_${var.period}):avg:system.load.15{${join(",", compact(var.selector))}} by ${var.group_by} > ${var.critical_threshold}"

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
