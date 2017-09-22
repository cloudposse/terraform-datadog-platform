output "cpu_average_percent_id" {
  value = "${datadog_monitor.cpu_average.id}"
}

output "cpu_iowait_percent_id" {
  value = "${datadog_monitor.cpu_iowait.id}"
}

output "disk_read_percent_id" {
  value = "${datadog_monitor.disk_read.id}"
}

output "disk_write_percent_id" {
  value = "${datadog_monitor.disk_write.id}"
}

output "fs_inodes_free_id" {
  value = "${datadog_monitor.fs_inodes_free.id}"
}

output "disk_free_id" {
  value = "${datadog_monitor.disk_free.id}"
}

output "load_average_1min_id" {
  value = "${datadog_monitor.load_average_1.id}"
}

output "load_average_5min_id" {
  value = "${datadog_monitor.load_average_5.id}"
}

output "load_average_15min_id" {
  value = "${datadog_monitor.load_average_15.id}"
}

output "memory_free_id" {
  value = "${datadog_monitor.memory_free.id}"
}

output "swap_free_id" {
  value = "${datadog_monitor.swap_free.id}"
}

output "network_incoming_bytes_id" {
  value = "${datadog_monitor.network_incoming.id}"
}

output "network_outgoing_bytes_id" {
  value = "${datadog_monitor.network_outgoing.id}"
}

output "network_incoming_packets_per_sec" {
  value = "${datadog_monitor.network_incoming_packets.id}"
}

output "network_outgoing_packets_per_sec" {
  value = "${datadog_monitor.network_outgoing_packets.id}"
}
