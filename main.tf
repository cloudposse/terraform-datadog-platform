module "label" {
  source     = "git::https://github.com/cloudposse/tf_label.git?ref=tags/0.2.0"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  tags       = "${var.tags}"
}

provider "datadog" {
  api_key = "${var.datadog_api_key}"
  app_key = "${var.datadog_app_key}"
}

resource "datadog_monitor" "default" {
  name               = "${module.label.id}"
  type               = "${var.alert_type}"
  message            = "${var.alert_message}. Notify: @${var.alert_user}"
  escalation_message = "${var.alert_escalation_message} @${var.alert_escalation_user}"

  query = "avg(last_1h):avg:aws.ec2.cpu{environment:foo,host:foo} by {host} > 2"

  thresholds {
    ok       = "${var.ok_state_value}"
    warning  = "${var.warning_state_value}"
    critical = "${var.critical_state_value}"
  }

  renotify_interval = "${var.renotify_interval_mins}"

  ## not important options
  //  notify_no_data    = false
  //  notify_audit = false
  //  timeout_h    = 60
  //  include_tags = true

  silenced {
    "*" = 0
  }
  tags = ["${module.label.tags}"]
}
