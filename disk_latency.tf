resource "datadog_monitor" "disk_read" {
  name    = "Disk read time overloaded ${module.label.id}"
  type    = "${var.alert_type}"
  message = "Disk read time overloaded ${var.read_percent_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.read_percent_time}):avg:system.disk.read_time_pct{host:${data.aws_instance.monitored.instance_id}} by {device,host} > ${var.read_percent_critical_state_value}"

  thresholds {
    ok       = "${var.read_percent_ok_state_value}"
    warning  = "${var.read_percent_warning_state_value}"
    critical = "${var.read_percent_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"

  tags = ["${module.label.tags}"]
}

resource "datadog_monitor" "disk_write" {
  name    = "Disk write time overloaded ${module.label.id}"
  type    = "${var.alert_type}"
  message = "Disk write time overloaded ${var.write_percent_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.write_percent_time}):avg:system.disk.write_time_pct{host:${data.aws_instance.monitored.instance_id}} by {device,host} > ${var.write_percent_critical_state_value}"

  thresholds {
    ok       = "${var.write_percent_ok_state_value}"
    warning  = "${var.write_percent_warning_state_value}"
    critical = "${var.write_percent_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"

  tags = ["${module.label.tags}"]
}
