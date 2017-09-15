variable "namespace" {}

variable "stage" {}

variable "name" {}

variable "delimiter" {
  default = "-"
}

variable "attributes" {
  type    = "list"
  default = []
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "datadog_api_key" {}

variable "datadog_app_key" {}

variable "alert_type" {
  default = "metric alert"
}

variable "instance" {}

variable "notify_no_data" {
  default = false
}

variable "new_host_delay" {
  default = "300"
}

variable "load_average_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "10m"
}

variable "load_average_ok_state_value" {
  default = "0"
}

variable "load_average_warning_state_value" {
  default = "1"
}

variable "load_average_critical_state_value" {
  default = "2"
}

variable "cpu_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "10m"
}

variable "cpu_ok_state_value" {
  description = "Percent of CPU usage"
  default     = "20"
}

variable "cpu_warning_state_value" {
  description = "Percent of CPU usage"
  default     = "50"
}

variable "cpu_critical_state_value" {
  description = "Percent of CPU usage"
  default     = "80"
}

variable "renotify_interval_mins" {
  default = "60"
}

variable "swap_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "1h"
}

variable "swap_ok_state_value" {
  description = "Count in bytes"
  default     = "104857600"
}

variable "swap_warning_state_value" {
  description = "Count in bytes"
  default     = "54857600"
}

variable "swap_critical_state_value" {
  description = "Count in bytes"
  default     = "24857600"
}

variable "memory_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "1h"
}

variable "memory_ok_state_value" {
  description = "Count in bytes"
  default     = "104857600"
}

variable "memory_warning_state_value" {
  description = "Count in bytes"
  default     = "54857600"
}

variable "memory_critical_state_value" {
  description = "Count in bytes"
  default     = "24857600"
}

variable "bytes_rcvd_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "1h"
}

variable "bytes_rcvd_ok_state_value" {
  description = "Count in bytes"
  default     = "1048576"
}

variable "bytes_rcvd_warning_state_value" {
  description = "Count in bytes"
  default     = "5485760"
}

variable "bytes_rcvd_critical_state_value" {
  description = "Count in bytes"
  default     = "24857600"
}

variable "bytes_sent_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "1h"
}

variable "bytes_sent_ok_state_value" {
  description = "Count in bytes"
  default     = "1048576"
}

variable "bytes_sent_warning_state_value" {
  description = "Count in bytes"
  default     = "5485760"
}

variable "bytes_sent_critical_state_value" {
  description = "Count in bytes"
  default     = "24857600"
}

variable "packets_in_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "1h"
}

variable "packets_in_ok_state_value" {
  description = "Count of packages per second"
  default     = "1000"
}

variable "packets_in_warning_state_value" {
  description = "Count of packages per second"
  default     = "10000"
}

variable "packets_in_critical_state_value" {
  description = "Count of packages per second"
  default     = "100000"
}

variable "packets_out_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "1h"
}

variable "packets_out_ok_state_value" {
  description = "Count of packages per second"
  default     = "1000"
}

variable "packets_out_warning_state_value" {
  description = "Count of packages per second"
  default     = "10000"
}

variable "packets_out_critical_state_value" {
  description = "Count of packages per second"
  default     = "100000"
}

variable "freespace_bytes_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "1h"
}

variable "freespace_bytes_ok_state_value" {
  description = "Count in bytes"
  default     = "1048576"
}

variable "freespace_bytes_warning_state_value" {
  description = "Count in bytes"
  default     = "5485760"
}

variable "freespace_bytes_critical_state_value" {
  description = "Count in bytes"
  default     = "24857600"
}

variable "free_inodes_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "1h"
}

variable "free_inodes_ok_state_value" {
  description = "Count of packages per second"
  default     = "100000"
}

variable "free_inodes_warning_state_value" {
  description = "Count of packages per second"
  default     = "50000"
}

variable "free_inodes_critical_state_value" {
  description = "Count of packages per second"
  default     = "1000"
}

variable "write_percent_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "1h"
}

variable "write_percent_ok_state_value" {
  description = "Percent of time spent writing to disk"
  default     = "40"
}

variable "write_percent_warning_state_value" {
  description = "Percent of time spent writing to disk"
  default     = "60"
}

variable "write_percent_critical_state_value" {
  description = "Percent of time spent writing to disk"
  default     = "80"
}

variable "read_percent_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "1h"
}

variable "read_percent_ok_state_value" {
  description = "Percent of time spent writing to disk"
  default     = "40"
}

variable "read_percent_warning_state_value" {
  description = "Percent of time spent writing to disk"
  default     = "60"
}

variable "read_percent_critical_state_value" {
  description = "Percent of time spent writing to disk"
  default     = "80"
}

variable "io_percent_time" {
  description = "Possible value is: any integer with m/h (eg minutes, hours)"
  default     = "1h"
}

variable "io_percent_ok_state_value" {
  description = "Percent of time spent writing to disk"
  default     = "40"
}

variable "io_percent_warning_state_value" {
  description = "Percent of time spent writing to disk"
  default     = "60"
}

variable "io_percent_critical_state_value" {
  description = "Percent of time spent writing to disk"
  default     = "80"
}

variable "active" {
  default = "1"
}
