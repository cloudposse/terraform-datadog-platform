variable "namespace" {
  description = "Namespace (e.g. cp or cloudposse)."
}

variable "stage" {
  description = "Stage (e.g. prod, dev, staging)."
}

variable "name" {
  description = "Name (e.g. bastion or db)."
}

variable "delimiter" {
  default = "-"
}

variable "attributes" {
  description = "Additional attributes (e.g. policy or role)."
  type        = "list"
  default     = []
}

variable "tags" {
  description = "Additional tags (e.g. map('BusinessUnit','XYZ')."
  type        = "map"
  default     = {}
}

variable "datadog_api_key" {
  description = "Datadog API key. This can also be set via the DATADOG_API_KEY environment variable."
}

variable "datadog_app_key" {
  description = "Datadog APP key. This can also be set via the DATADOG_APP_KEY environment variable."
}

variable "monitor_enabled" {
  description = "State of monitor."
  default     = true
}

variable "monitor_silenced" {
  description = "Each scope will be muted until the given POSIX timestamp or forever if the value is 0."
  default     = "0"
}

variable "alert_type" {
  description = "The type of the monitor (e.g. metric alert, service check, event alert, query alert)."
  default     = "metric alert"
}

variable "instance_id" {
  description = "AWS EC2 instance ID."
}

variable "notify_no_data" {
  description = "A boolean indicating whether this monitor will notify when data stops reporting."
  default     = "false"
}

variable "new_host_delay" {
  description = "Time (in seconds) to allow a host to boot and applications to fully start before starting the evaluation of monitor results."
  default     = "300"
}

variable "renotify_interval_mins" {
  description = "The number of minutes after the last notification before a monitor will re-notify on the current status. It will only re-notify if it's not resolved."
  default     = "60"
}

variable "load_average_time" {
  description = "Alert time period for load average. Possible value is: any integer with m/h (e.g. minutes, hours)."
  default     = "10m"
}

variable "load_average_ok_threshold_value" {
  description = "Value of Load Average for ok threshold."
  default     = "1"
}

variable "load_average_warning_threshold_value" {
  description = "Value of Load Average for warning threshold."
  default     = "5"
}

variable "load_average_critical_threshold_value" {
  description = "Value of Load Average for critical threshold."
  default     = "10"
}

variable "cpu_time" {
  description = "Alert time period for CPU usage. Possible value is: any integer with m/h (e.g. minutes, hours)."
  default     = "10m"
}

variable "cpu_ok_threshold_value" {
  description = "Percent of CPU usage for ok threshold."
  default     = "20"
}

variable "cpu_warning_threshold_value" {
  description = "Percent of CPU usage for warning threshold."
  default     = "50"
}

variable "cpu_critical_threshold_value" {
  description = "Percent of CPU usage for cirtical threshold."
  default     = "80"
}

variable "swap_time" {
  description = "Alert time period for Swap usage. Possible value is: any integer with m/h (eg minutes, hours)."
  default     = "1h"
}

variable "swap_ok_threshold_value" {
  description = "Count in bytes of swap  ok threshold."
  default     = "104857600"
}

variable "swap_warning_threshold_value" {
  description = "Count in bytes of swap for warning threshold."
  default     = "54857600"
}

variable "swap_critical_threshold_value" {
  description = "Count in bytes of swap for critical threshold."
  default     = "24857600"
}

variable "memory_time" {
  description = "Alert time period for memmory usage. Possible value is: any integer with m/h (eg minutes, hours)."
  default     = "1h"
}

variable "memory_ok_threshold_value" {
  description = "Count in bytes of memory for ok threshold."
  default     = "104857600"
}

variable "memory_warning_threshold_value" {
  description = "Count in bytes of memory for warning threshold."
  default     = "54857600"
}

variable "memory_critical_threshold_value" {
  description = "Count in bytes of memory forcritical threshold."
  default     = "24857600"
}

variable "bytes_rcvd_time" {
  description = "Alert time period for bytes received. Possible value is: any integer with m/h (eg minutes, hours)."
  default     = "1h"
}

variable "bytes_rcvd_ok_threshold_value" {
  description = "Count in bytes of bytes received for ok threshold."
  default     = "1048576"
}

variable "bytes_rcvd_warning_threshold_value" {
  description = "Count in bytes of bytes received for warning threshold."
  default     = "5485760"
}

variable "bytes_rcvd_critical_threshold_value" {
  description = "Count in bytes of bytes received for cirtical threshold."
  default     = "24857600"
}

variable "bytes_sent_time" {
  description = "Alert time period for bytes sent. Possible value is: any integer with m/h (eg minutes, hours)."
  default     = "1h"
}

variable "bytes_sent_ok_threshold_value" {
  description = "Count in bytes of bytes sent for ok threshold."
  default     = "1048576"
}

variable "bytes_sent_warning_threshold_value" {
  description = "Count in bytes of bytes sent for warning threshold."
  default     = "5485760"
}

variable "bytes_sent_critical_threshold_value" {
  description = "Count in bytes of bytes sent for cirtical threshold."
  default     = "24857600"
}

variable "packets_in_time" {
  description = "Alert time period for packages per second received. Possible value is: any integer with m/h (eg minutes, hours)."
  default     = "1h"
}

variable "packets_in_ok_threshold_value" {
  description = "Count of packages per second received for ok threshold."
  default     = "1000"
}

variable "packets_in_warning_threshold_value" {
  description = "Count of packages per second received for warning threshold."
  default     = "10000"
}

variable "packets_in_critical_threshold_value" {
  description = "Count of packages per second received for cirtical threshold."
  default     = "100000"
}

variable "packets_out_time" {
  description = "Alert time period for packages per second sent. Possible value is: any integer with m/h (eg minutes, hours)."
  default     = "1h"
}

variable "packets_out_ok_threshold_value" {
  description = "Count of packages per second sent for ok threshold."
  default     = "1000"
}

variable "packets_out_warning_threshold_value" {
  description = "Count of packages per second sent for warning threshold."
  default     = "10000"
}

variable "packets_out_critical_threshold_value" {
  description = "Count of packages per second sent for cirtical threshold."
  default     = "100000"
}

variable "disk_free_time" {
  description = "Alert time period for free disk space. Possible value is: any integer with m/h (eg minutes, hours)."
  default     = "1h"
}

variable "disk_free_ok_threshold_value" {
  description = "Count in bytes of free disk space for ok threshold."
  default     = "1048576"
}

variable "disk_free_warning_threshold_value" {
  description = "Count in bytes of free disk space for warning threshold."
  default     = "5485760"
}

variable "disk_free_critical_threshold_value" {
  description = "Count in bytes of free disk space for critical threshold."
  default     = "24857600"
}

variable "fs_inodes_free_time" {
  description = "Alert time for count of free inodes. Possible value is: any integer with m/h (eg minutes, hours)."
  default     = "1h"
}

variable "fs_inodes_free_ok_threshold_value" {
  description = "Count of free inodes for ok threshold."
  default     = "100000"
}

variable "fs_inodes_free_warning_threshold_value" {
  description = "Count of free inodes for warning threshold."
  default     = "50000"
}

variable "fs_inodes_free_critical_threshold_value" {
  description = "Count of free inodes for critical threshold."
  default     = "1000"
}

variable "write_percent_time" {
  description = "Alert time for percent of time spent writing to disk. Possible value is: any integer with m/h (eg minutes, hours)."
  default     = "1h"
}

variable "write_percent_ok_threshold_value" {
  description = "Percent of time spent writing to disk for ok threshold."
  default     = "40"
}

variable "write_percent_warning_threshold_value" {
  description = "Percent of time spent writing to disk for warning threshold."
  default     = "60"
}

variable "write_percent_critical_threshold_value" {
  description = "Percent of time spent writing to disk for critical threshold."
  default     = "80"
}

variable "read_percent_time" {
  description = "Alert time for percent of time spent reading to disk. Possible value is: any integer with m/h (eg minutes, hours)."
  default     = "1h"
}

variable "read_percent_ok_threshold_value" {
  description = "Percent of time spent reading to disk for ok threshold."
  default     = "40"
}

variable "read_percent_warning_threshold_value" {
  description = "Percent of time spent reading to disk for warning threshold."
  default     = "60"
}

variable "read_percent_critical_threshold_value" {
  description = "Percent of time spent reading to disk for ok threshold."
  default     = "80"
}

variable "cpu_io_percent_time" {
  description = "Alert time for CPU iowait usage. Possible value is: any integer with m/h (eg minutes, hours)."
  default     = "1h"
}

variable "io_percent_ok_threshold_value" {
  description = "Percent of CPU iowait usage for ok threshold."
  default     = "40"
}

variable "io_percent_warning_threshold_value" {
  description = "Percent of CPU iowait usage for warning threshold."
  default     = "60"
}

variable "io_percent_critical_threshold_value" {
  description = "Percent of CPU iowait usage for critical threshold."
  default     = "80"
}
