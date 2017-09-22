# System metrics in Datadog

Terraform module to provision Standard System Monitors (cpu, memory, swap, io, etc) in Datadog.

## Usage

```terraform
module "monitors" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor/system.git?ref=master"
  namespace       = "${var.namespace}"
  stage           = "${var.stage}"
  name            = "${var.name}"
  datadog_api_key = "${var.datadog_api_key}"
  datadog_app_key = "${var.datadog_app_key}"
  instance_id     = "${var.instance_id}"
}
```

## Variables

| Name                                      |    Default     | Description                                                                                                                                           | Required |
|:------------------------------------------|:--------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`                               |    `global`    | Namespace (e.g. `cp` or `cloudposse`) - required for `tf_label` module                                                                                |   Yes    |
| `stage`                                   |   `default`    | Stage (e.g. `prod`, `dev`, `staging` - required for `tf_label` module                                                                                 |   Yes    |
| `name`                                    |       ``       | Name  (e.g. `bastion` or `db`)                                                                                                                        |   Yes    |
| `attributes`                              |      `[]`      | Additional attributes (e.g. `policy` or `role`)                                                                                                       |    No    |
| `tags`                                    |      `{}`      | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                                                                                                    |    No    |
| `datadog_api_key`                         |       ``       | Datadog API key                                                                                                                                       |   Yes    |
| `datadog_app_key`                         |       ``       | Datadog APP key                                                                                                                                       |   Yes    |
| `monitor_enabled`                         |     `true`     | State of monitor                                                                                                                                      |    No    |
| `monitor_silenced`                        |      `0`       | Each scope will be muted until the given POSIX timestamp or forever if the value is 0                                                                 |    No    |
| `renotify_interval_mins`                  |       ``       | The number of minutes after the last notification before a monitor will re-notify on the current status. It will only re-notify if it's not resolved. |    No    |
| `alert_type`                              | `metric alert` | The type of the monitor (e.g. `metric alert`, `service check`, `event alert, `query alert`)                                                           |    No    |
| `instance_id`                             |       ``       | AWS EC2 instance ID                                                                                                                                   |   Yes    |
| `new_host_delay`                          |     `300`      | Time (in seconds) to allow a host to boot and applications to fully start before starting the evaluation of monitor results                           |    No    |
| `notify_no_data`                          |    `false`     | A boolean indicating whether this monitor will notify when data stops reporting                                                                       |    No    |
| `load_average_time`                       |     `10m`      | Alert time period for Load Average. Possible value is: any integer with m/h (e.g. minutes, hours)                                                     |    No    |
| `load_average_ok_threshold_value`         |      `1`       | Value of Load Average for ok threshold                                                                                                                |    No    |
| `load_average_warning_threshold_value`    |      `5`       | Value of Load Average for warning threshold                                                                                                           |    No    |
| `load_average_critical_threshold_value`   |      `10`      | Value of Load Average for critical threshold                                                                                                          |    No    |
| `cpu_time`                                |     `10m`      | Alert time period for CPU usage. Possible value is: any integer with m/h (e.g. minutes, hours)                                                        |    No    |
| `cpu_ok_threshold_value`                  |      `20`      | Percent of CPU usage for ok threshold                                                                                                                 |    No    |
| `cpu_warning_threshold_value`             |      `50`      | Percent of CPU usage for warning threshold                                                                                                            |    No    |
| `cpu_critical_threshold_value`            |      `80`      | Percent of CPU usage for critical threshold                                                                                                           |    No    |
| `swap_time`                               |      `1h`      | Alert time period for Swap usage. Possible value is: any integer with m/h (eg minutes, hours)                                                         |    No    |
| `swap_ok_threshold_value`                 |  `104857600`   | Count in bytes of swap for ok threshold                                                                                                               |    No    |
| `swap_warning_threshold_value`            |   `54857600`   | Count in bytes of swap for warning threshold                                                                                                          |    No    |
| `swap_critical_threshold_value`           |   `24857600`   | Count in bytes of swap for critical threshold                                                                                                         |    No    |
| `memory_ok_threshold_value`               |  `104857600`   | Count in bytes of memory for ok threshold                                                                                                             |    No    |
| `memory_warning_threshold_value`          |   `54857600`   | Count in bytes of memory for warning threshold                                                                                                        |    No    |
| `memory_critical_threshold_value`         |   `24857600`   | Count in bytes of memory for critical threshold                                                                                                       |    No    |
| `bytes_rcvd_time`                         |      `1h`      | Alert time period for bytes received. Possible value is: any integer with m/h (eg minutes, hours)                                                     |    No    |
| `bytes_rcvd_ok_threshold_value`           |   `1048576`    | Count in bytes of bytes received for ok threshold                                                                                                     |    No    |
| `bytes_rcvd_warning_threshold_value`      |   `5485760`    | Count in bytes of bytes received for warning threshold                                                                                                |    No    |
| `bytes_rcvd_critical_threshold_value`     |   `24857600`   | Count in bytes of bytes received for critical threshold                                                                                               |    No    |
| `bytes_sent_time`                         |      `1h`      | Alert time period for bytes sent. Possible value is: any integer with m/h (eg minutes, hours)                                                         |    No    |
| `bytes_sent_ok_threshold_value`           |   `1048576`    | Count in bytes of bytes sent for ok threshold                                                                                                         |    No    |
| `bytes_sent_warning_threshold_value`      |   `5485760`    | Count in bytes of bytes sent for warning threshold                                                                                                    |    No    |
| `bytes_sent_critical_threshold_value`     |   `24857600`   | Count in bytes of bytes sent for critical threshold                                                                                                   |    No    |
| `packets_in_time`                         |      `1h`      | Alert time period for packages per second received. Possible value is: any integer with m/h (eg minutes, hours)                                       |    No    |
| `packets_in_ok_threshold_value`           |     `1000`     | Count of packages per second received for ok threshold                                                                                                |    No    |
| `packets_in_warning_threshold_value`      |    `10000`     | Count of packages per second received for warning threshold                                                                                           |    No    |
| `packets_in_critical_threshold_value`     |    `100000`    | Count of packages per second received for critical threshold                                                                                          |    No    |
| `packets_out_time`                        |      `1h`      | Alert time period for packages per second sent. Possible value is: any integer with m/h (eg minutes, hours)                                           |    No    |
| `packets_out_ok_threshold_value`          |     `1000`     | Count of packages per second sent for ok threshold                                                                                                    |    No    |
| `packets_out_warning_threshold_value`     |    `10000`     | Count of packages per second sent for warning threshold                                                                                               |    No    |
| `packets_out_critical_threshold_value`    |    `100000`    | Count of packages per second sent for critical threshold                                                                                              |    No    |
| `disk_free_time`                          |      `1h`      | Alert time period for free disk space. Possible value is: any integer with m/h (eg minutes, hours)                                                    |    No    |
| `disk_free_ok_threshold_value`            |   `1048576`    | Count in bytes of free disk space for ok threshold                                                                                                    |    No    |
| `disk_free_warning_threshold_value`       |   `5485760`    | Count in bytes of free disk space for warning threshold                                                                                               |    No    |
| `disk_free_critical_threshold_value`      |   `24857600`   | Count in bytes of free disk space for critical threshold                                                                                              |    No    |
| `fs_inodes_free_time`                     |      `1h`      | Alert time for count of free inodes. Possible value is: any integer with m/h (eg minutes, hours)                                                      |    No    |
| `fs_inodes_free_ok_threshold_value`       |    `100000`    | Count of free inodes for ok threshold                                                                                                                 |    No    |
| `fs_inodes_free_warning_threshold_value`  |    `50000`     | Count of free inodes for warning threshold                                                                                                            |    No    |
| `fs_inodes_free_critical_threshold_value` |     `1000`     | Count of free inodes for critical threshold                                                                                                           |    No    |
| `write_percent_time`                      |      `1h`      | Alert time for percent of time spent writing to disk. Possible value is: any integer with m/h (eg minutes, hours)                                     |    No    |
| `write_percent_ok_threshold_value`        |      `40`      | Percent of time spent writing to disk for ok threshold                                                                                                |    No    |
| `write_percent_warning_threshold_value`   |      `60`      | Percent of time spent writing to disk for warning  threshold                                                                                          |    No    |
| `write_percent_critical_threshold_value`  |      `80`      | Percent of time spent writing to disk for critical  threshold                                                                                         |    No    |
| `read_percent_time`                       |      `1h`      | Alert time for percent of time spent reading to disk. Possible value is: any integer with m/h (eg minutes, hours)                                     |    No    |
| `read_percent_ok_threshold_value`         |      `40`      | Percent of time spent reading to disk for ok threshold                                                                                                |    No    |
| `read_percent_warning_threshold_value`    |      `60`      | Percent of time spent reading to disk for warning threshold                                                                                           |    No    |
| `read_percent_critical_threshold_value`   |      `80`      | Percent of time spent reading to disk for critical threshold                                                                                          |    No    |
| `cpu_io_percent_time`                     |      `1h`      | Alert time for CPU iowait usage. Possible value is: any integer with m/h (eg minutes, hours)                                                          |    No    |
| `io_percent_ok_threshold_value`           |      `40`      | Percent of CPU iowait usage for ok threshold                                                                                                          |    No    |
| `io_percent_warning_threshold_value`      |      `60`      | Percent of CPU iowait usage for warning threshold                                                                                                     |    No    |
| `io_percent_critical_threshold_value`     |      `80`      | Percent of CPU iowait usage for critical threshold                                                                                                    |    No    |


## Outputs

| Name                                  | Description                                              |
|:--------------------------------------|:---------------------------------------------------------|
| `cpu_average_percent_id`              | ID of the Datadog monitor for CPU usage.                 |
| `cpu_iowait_percent_id`               | ID of the Datadog monitor for CPU iowait usage.          |
| `disk_free_id`                        | ID of the Datadog monitor for free disk space            |
| `disk_read_percent_id`                | ID of the Datadog monitor for disk read percent time     |
| `disk_write_percent_id`               | ID of the Datadog monitor for disk write percent time    |
| `fs_inodes_free_id`                   | ID of the Datadog monitor for free inodes                |
| `load_average_15min_id`               | ID of the Datadog monitor for Load Average 15 min        |
| `load_average_1min_id`                | ID of the Datadog monitor for Load Average 1 min         |
| `load_average_5min_id`                | ID of the Datadog monitor for Load Average 5 min         |
| `memory_free_id`                      | ID of the Datadog monitor for count of free memory bytes |
| `network_incoming_bytes_id`           | ID of the Datadog monitor for incoming bytes             |
| `network_incoming_packets_per_sec_id` | ID of the Datadog monitor for incoming p/s               |
| `network_outgoing_bytes_id`           | ID of the Datadog monitor for outgoing bytes             |
| `network_outgoing_packets_per_sec_id` | ID of the Datadog monitor for outgoing p/s               |
| `swap_free_id`                        | ID of the Datadog monitor for count of free swap bytes   |
