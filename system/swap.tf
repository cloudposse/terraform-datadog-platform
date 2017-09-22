resource "datadog_monitor" "swap_free" {
  count   = "${var.monitor_enabled}"
  name    = "Insufficient of free swap space ${module.label.id}"
  type    = "${var.alert_type}"
  message = "Insufficient of free swap space on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.swap_time}):avg:system.swap.free{host:${data.aws_instance.monitored.instance_id}} by {host} < ${var.swap_critical_threshold_value}"

  thresholds {
    ok       = "${var.swap_ok_threshold_value}"
    warning  = "${var.swap_warning_threshold_value}"
    critical = "${var.swap_critical_threshold_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = ["${module.label.id}"]
}
