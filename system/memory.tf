resource "datadog_monitor" "memory_free" {
  count   = "${var.monitor_enabled}"
  name    = "Insufficient of free memory space ${module.label.id}"
  type    = "${var.alert_type}"
  message = "Insufficient of free memory space on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.memory_time}):avg:system.mem.free{host:${data.aws_instance.monitored.instance_id}} by {host} < ${var.memory_critical_threshold_value}"

  thresholds {
    ok       = "${var.memory_ok_threshold_value}"
    warning  = "${var.memory_warning_threshold_value}"
    critical = "${var.memory_critical_threshold_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = ["${module.label.id}"]
}
