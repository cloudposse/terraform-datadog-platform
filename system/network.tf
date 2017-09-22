resource "datadog_monitor" "network_incoming" {
  count   = "${var.monitor_enabled}"
  name    = "High incoming traffic ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High incoming traffic last ${var.bytes_rcvd_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.bytes_rcvd_time}):avg:system.net.bytes_rcvd{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.bytes_rcvd_critical_threshold_value}"

  thresholds {
    ok       = "${var.bytes_rcvd_ok_threshold_value}"
    warning  = "${var.bytes_rcvd_warning_threshold_value}"
    critical = "${var.bytes_rcvd_critical_threshold_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = ["${module.label.id}"]
}

resource "datadog_monitor" "network_outgoing" {
  count   = "${var.monitor_enabled}"
  name    = "High outgoing traffic ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High outgoing traffic last ${var.bytes_sent_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.bytes_sent_time}):avg:system.net.bytes_sent{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.bytes_sent_critical_threshold_value}"

  thresholds {
    ok       = "${var.bytes_sent_ok_threshold_value}"
    warning  = "${var.bytes_sent_warning_threshold_value}"
    critical = "${var.bytes_sent_critical_threshold_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = ["${module.label.id}"]
}

resource "datadog_monitor" "network_incoming_packets" {
  count   = "${var.monitor_enabled}"
  name    = "High count of incoming packets ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High count of incoming packets last ${var.packets_in_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.packets_in_time}):avg:system.net.packets_in.count{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.packets_in_critical_threshold_value}"

  thresholds {
    ok       = "${var.packets_in_ok_threshold_value}"
    warning  = "${var.packets_in_warning_threshold_value}"
    critical = "${var.packets_in_critical_threshold_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = ["${module.label.id}"]
}

resource "datadog_monitor" "network_outgoing_packets" {
  count   = "${var.monitor_enabled}"
  name    = "High count of outgoing packets ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High count of outgoing packets last ${var.packets_out_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.public_ip}"
  query   = "avg(last_${var.packets_out_time}):avg:system.net.packets_out.count{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.packets_out_critical_threshold_value}"

  thresholds {
    ok       = "${var.packets_out_ok_threshold_value}"
    warning  = "${var.packets_out_warning_threshold_value}"
    critical = "${var.packets_out_critical_threshold_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"
  new_host_delay    = "${var.new_host_delay}"
  notify_no_data    = "${var.notify_no_data}"

  silenced {
    "*" = "${var.monitor_silenced}"
  }

  tags = ["${module.label.id}"]
}
