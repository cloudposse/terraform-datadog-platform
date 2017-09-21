resource "datadog_monitor" "cpu_average" {
  name    = "${module.label.id}"
  type    = "${var.alert_type}"
  message = "High CPU usage last ${var.cpu_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.cpu_time}):avg:system.cpu.system{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.cpu_critical_state_value}"

  thresholds {
    ok       = "${var.cpu_ok_state_value}"
    warning  = "${var.cpu_warning_state_value}"
    critical = "${var.cpu_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.active}"
  }

  tags = ["${module.label.id}"]
}

resource "datadog_monitor" "cpu_iowait" {
  name    = "Disk write time overloaded ${module.label.id}"
  type    = "${var.alert_type}"
  message = "Disk write time overloaded last ${var.cpu_io_percent_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.cpu_io_percent_time}):avg:system.cpu.iowait{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.io_percent_critical_state_value}"

  thresholds {
    ok       = "${var.io_percent_ok_state_value}"
    warning  = "${var.io_percent_warning_state_value}"
    critical = "${var.io_percent_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.active}"
  }

  tags = ["${module.label.id}"]
}
