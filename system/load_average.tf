resource "datadog_monitor" "load_average_1" {
  count   = "${var.monitor_enabled}"
  name    = "High load average 1 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average 1 last ${var.load_average["time"]} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.load_average["time"]}):avg:system.load.1{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.load_average["critical_threshold"]}"

  thresholds {
    ok       = "${var.load_average["ok_threshold"]}"
    warning  = "${var.load_average["warning_threshold"]}"
    critical = "${var.load_average["critical_threshold"]}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = ["${module.label.id}"]
}

resource "datadog_monitor" "load_average_5" {
  count   = "${var.monitor_enabled}"
  name    = "High load average 5 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average 5 last ${var.load_average["time"]}m on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.load_average["time"]}):avg:system.load.5{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.load_average["critical_threshold"]}"

  thresholds {
    ok       = "${var.load_average["ok_threshold"]}"
    warning  = "${var.load_average["warning_threshold"]}"
    critical = "${var.load_average["critical_threshold"]}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = ["${module.label.id}"]
}

resource "datadog_monitor" "load_average_15" {
  count   = "${var.monitor_enabled}"
  name    = "High load average 15 ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High load average last 15 last ${var.load_average["time"]} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.load_average["time"]}):avg:system.load.15{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.load_average["critical_threshold"]}"

  thresholds {
    ok       = "${var.load_average["ok_threshold"]}"
    warning  = "${var.load_average["warning_threshold"]}"
    critical = "${var.load_average["critical_threshold"]}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = ["${module.label.id}"]
}
