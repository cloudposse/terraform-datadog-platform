resource "datadog_monitor" "load_average_1" {
  count   = "${var.monitor_enabled}"
  name    = "High load average 1 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average 1 last ${var.load_average["period"]} on host: {host.name} with IP: {host.ip} ${var.notify}"
  query   = "avg(last_${var.load_average["period"]}):avg:system.load.1{${join(",", compact(var.datadog_monitor_selector))}} by {host} > ${var.load_average["critical_threshold"]}"

  thresholds {
    ok       = "${var.load_average["ok_threshold"]}"
    warning  = "${var.load_average["warning_threshold"]}"
    critical = "${var.load_average["critical_threshold"]}"
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
  count   = "${var.monitor_enabled}"
  name    = "High load average 5 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average 5 last ${var.load_average["period"]} on host: {host.name} with IP: {host.ip} ${var.notify}"
  query   = "avg(last_${var.load_average["period"]}):avg:system.load.5{${join(",", compact(var.datadog_monitor_selector))}} by {host} > ${var.load_average["critical_threshold"]}"

  thresholds {
    ok       = "${var.load_average["ok_threshold"]}"
    warning  = "${var.load_average["warning_threshold"]}"
    critical = "${var.load_average["critical_threshold"]}"
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
  count   = "${var.monitor_enabled}"
  name    = "High load average 15 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average last 15 last ${var.load_average["period"]} on host: {host.name} with IP: {host.ip} ${var.notify}"
  query   = "avg(last_${var.load_average["period"]}):avg:system.load.15{${join(",", compact(var.datadog_monitor_selector))}} by {host} > ${var.load_average["critical_threshold"]}"

  thresholds {
    ok       = "${var.load_average["ok_threshold"]}"
    warning  = "${var.load_average["warning_threshold"]}"
    critical = "${var.load_average["critical_threshold"]}"
  }

  renotify_interval = "${var.renotify_interval}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = "${var.datadog_monitor_tags}"
}
