resource "datadog_monitor" "fs_inodes_free" {
  count   = "${var.monitor_enabled}"
  name    = "Insufficient of count free inodes ${module.label.id}"
  type    = "${var.alert_type}"
  message = "Insufficient of count free inodes on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.fs_inodes_free_time}):avg:system.fs.inodes.free{host:${data.aws_instance.monitored.instance_id}} by {device,host} < ${var.fs_inodes_free_critical_threshold_value}"

  thresholds {
    ok       = "${var.fs_inodes_free_ok_threshold_value}"
    warning  = "${var.fs_inodes_free_warning_threshold_value}"
    critical = "${var.fs_inodes_free_critical_threshold_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = ["${module.label.id}"]
}

resource "datadog_monitor" "disk_free" {
  count   = "${var.monitor_enabled}"
  name    = "Insufficient of free disk space ${module.label.id}"
  type    = "${var.alert_type}"
  message = "Insufficient of free disk space on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.disk_free_time}):avg:system.disk.free{host:${data.aws_instance.monitored.instance_id}} by {device,host} < ${var.disk_free_critical_threshold_value}"

  thresholds {
    ok       = "${var.disk_free_ok_threshold_value}"
    warning  = "${var.disk_free_warning_threshold_value}"
    critical = "${var.disk_free_critical_threshold_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = ["${module.label.id}"]
}
