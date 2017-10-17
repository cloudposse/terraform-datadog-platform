output "load_average_1_id" {
  value = "${datadog_monitor.load_average_1.id}"
}

output "load_average_5_id" {
  value = "${datadog_monitor.load_average_5.id}"
}

output "load_average_15_id" {
  value = "${datadog_monitor.load_average_15.id}"
}
