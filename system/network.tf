resource "datadog_monitor" "network_incoming" {
  name    = "High incoming traffic ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High incoming traffic ${var.bytes_rcvd_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.bytes_rcvd_time}):avg:system.net.bytes_rcvd{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.bytes_rcvd_critical_state_value}"

  thresholds {
    ok       = "${var.bytes_rcvd_ok_state_value}"
    warning  = "${var.bytes_rcvd_warning_state_value}"
    critical = "${var.bytes_rcvd_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"

  tags = ["${module.label.tags}"]
}

resource "datadog_monitor" "network_outgoing" {
  name    = "High outgoing traffic ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High outgoing traffic ${var.bytes_sent_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.bytes_sent_time}):avg:system.net.bytes_sent{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.bytes_sent_critical_state_value}"

  thresholds {
    ok       = "${var.bytes_sent_ok_state_value}"
    warning  = "${var.bytes_sent_warning_state_value}"
    critical = "${var.bytes_sent_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"

  tags = ["${module.label.tags}"]
}

resource "datadog_monitor" "network_incoming_packets" {
  name    = "High count of incoming packets ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High count of incoming packets ${var.packets_in_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.packets_in_time}):avg:system.net.packets_in.count{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.packets_in_critical_state_value}"

  thresholds {
    ok       = "${var.packets_in_ok_state_value}"
    warning  = "${var.packets_in_warning_state_value}"
    critical = "${var.packets_in_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"

  tags = ["${module.label.tags}"]
}

resource "datadog_monitor" "network_outgoing_packets" {
  name    = "High count of outgoing packets ${module.label.id}"
  type    = "${var.alert_type}"
  message = "High count of outgoing packets ${var.packets_out_time} on host: ${data.aws_instance.monitored.instance_id} with IP: ${data.aws_instance.monitored.instance_id.public_ip}"
  query   = "avg(last_${var.packets_out_time}):avg:system.net.packets_out.count{host:${data.aws_instance.monitored.instance_id}} by {host} > ${var.packets_out_critical_state_value}"

  thresholds {
    ok       = "${var.packets_out_ok_state_value}"
    warning  = "${var.packets_out_warning_state_value}"
    critical = "${var.packets_out_critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"

  tags = ["${module.label.tags}"]
}
