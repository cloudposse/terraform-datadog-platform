resource "datadog_monitor" "load_average_1" {
  name    = "High load average 1 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average 1 last ${var.la_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.la_time}):avg:system.load.1{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.la_critical_state_value}"

  thresholds {
    ok       = "${var.la_ok_state_value}"
    warning  = "${var.la_warning_state_value}"
    critical = "${var.la_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"

  tags = ["${module.label.tags}"]
}

resource "datadog_monitor" "load_average_5" {
  name    = "High load average 5 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average 5 last ${var.la_time}m on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.la_time}):avg:system.load.5{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.la_critical_state_value}"

  thresholds {
    ok       = "${var.la_ok_state_value}"
    warning  = "${var.la_warning_state_value}"
    critical = "${var.la_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"

  tags = ["${module.label.tags}"]
}

resource "datadog_monitor" "load_average_15" {
  name    = "High load average 15 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average last 15 ${var.la_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.la_time}):avg:system.load.15{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.la_critical_state_value}"

  thresholds {
    ok       = "${var.la_ok_state_value}"
    warning  = "${var.la_warning_state_value}"
    critical = "${var.la_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"

  tags = ["${module.label.tags}"]
}
