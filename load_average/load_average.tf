resource "datadog_monitor" "load_average_1" {
  count   = "${var.monitor_enabled ? 1 : 0}"
  name    = "High load average 1 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High 1m load average for last ${var.period} on host {host.name} ({host.ip}) ${var.notify}"
  query   = "avg(last_${var.period}):avg:system.load.1{${join(",", compact(var.selector))}} by {host} > ${var.critical_threshold}"

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
  count   = "${var.monitor_enabled ? 1 : 0}"
  name    = "High load average 5 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High 5m load average for last ${var.period} on host {host.name} ({host.ip}) ${var.notify}"
  query   = "avg(last_${var.period}):avg:system.load.5{${join(",", compact(var.selector))}} by {host} > ${var.critical_threshold}"

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
  count   = "${var.monitor_enabled ? 1 : 0}"
  name    = "High load average 15 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High 15m load average for last ${var.period} on host {host.name} ({host.ip}) ${var.notify}"
  query   = "avg(last_${var.period}):avg:system.load.15{${join(",", compact(var.selector))}} by {host} > ${var.critical_threshold}"

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
