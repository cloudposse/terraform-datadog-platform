resource "datadog_monitor" "fs_free_inodes" {
  name    = "Insufficient of count free inodes ${module.label.id}"
  type    = "${var.alert_type}"
  message = "Insufficient of count free inodes on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.free_inodes_time}):avg:system.fs.inodes.free{host:${data.aws_instance.monitored.instance_id}} by {device,host} < ${var.free_inodes_critical_state_value}"

  thresholds {
    ok       = "${var.free_inodes_ok_state_value}"
    warning  = "${var.free_inodes_warning_state_value}"
    critical = "${var.free_inodes_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.active}"
  }

  tags = ["${module.label.id}"]
}

resource "datadog_monitor" "disk_freespace" {
  name    = "Insufficient of free disk space ${module.label.id}"
  type    = "${var.alert_type}"
  message = "Insufficient of free disk space on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.freespace_bytes_time}):avg:system.disk.free{host:${data.aws_instance.monitored.instance_id}} by {device,host} < ${var.freespace_bytes_critical_state_value}"

  thresholds {
    ok       = "${var.freespace_bytes_ok_state_value}"
    warning  = "${var.freespace_bytes_warning_state_value}"
    critical = "${var.freespace_bytes_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.active}"
  }

  tags = ["${module.label.id}"]
}
