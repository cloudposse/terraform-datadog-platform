resource "datadog_monitor" "load_average_1" {
  name    = "High load average 1 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average 1 last ${var.load_average_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.load_average_time}):avg:system.load.1{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.load_average_critical_state_value}"

  thresholds {
    ok       = "${var.load_average_ok_state_value}"
    warning  = "${var.load_average_warning_state_value}"
    critical = "${var.load_average_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.active}"
  }

  tags = ["${module.label.tags}"]
}

resource "datadog_monitor" "load_average_5" {
  name    = "High load average 5 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average 5 last ${var.load_average_time}m on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.load_average_time}):avg:system.load.5{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.load_average_critical_state_value}"

  thresholds {
    ok       = "${var.load_average_ok_state_value}"
    warning  = "${var.load_average_warning_state_value}"
    critical = "${var.load_average_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.active}"
  }

  tags = ["${module.label.tags}"]
}

resource "datadog_monitor" "load_average_15" {
  name    = "High load average 15 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average last 15 ${var.load_average_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.load_average_time}):avg:system.load.15{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.load_average_critical_state_value}"

  thresholds {
    ok       = "${var.load_average_ok_state_value}"
    warning  = "${var.load_average_warning_state_value}"
    critical = "${var.load_average_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.active}"
  }

  tags = ["${module.label.tags}"]
}
