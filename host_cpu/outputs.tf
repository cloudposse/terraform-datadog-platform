output "cpu_average_percent_id" {
  value = "${datadog_monitor.cpu_average.id}"
}

output "cpu_iowait_percent_id" {
  value = "${datadog_monitor.cpu_iowait.id}"
}
