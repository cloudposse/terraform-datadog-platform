output "cpu_usage_id" {
  value = "${datadog_monitor.cpu_usage.id}"
}

output "cpu_iowait_id" {
  value = "${datadog_monitor.cpu_iowait.id}"
}
