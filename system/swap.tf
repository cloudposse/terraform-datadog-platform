resource "datadog_monitor" "swap_free" {
  name    = "Lack of free swap space ${module.label.id}"
  type    = "${var.alert_type}"
  message = "Lack of free swap space ${var.swap_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.swap_time}):avg:system.swap.free{host:${data.aws_instance.monitored.instance_id}} by {host} < ${var.swap_critical_state_value}"

  thresholds {
    ok       = "${var.swap_ok_state_value}"
    warning  = "${var.swap_warning_state_value}"
    critical = "${var.swap_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"

  tags = ["${module.label.tags}"]
}
