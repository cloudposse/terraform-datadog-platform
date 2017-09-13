output "cpu_average_percent" {
  value = "${datadog_monitor.cpu_average.id}"
}

output "cpu_iowait_percent" {
  value = "${datadog_monitor.cpu_iowait.id}"
}

output "disk_read_percent" {
  value = "${datadog_monitor.disk_read.id}"
}

output "disk_write_percent" {
  value = "${datadog_monitor.disk_write.id}"
}

output "fs_free_inodes_count" {
  value = "${datadog_monitor.fs_free_inodes.id}"
}

output "disk_freespace_bytes" {
  value = "${datadog_monitor.disk_freespace.id}"
}

output "load_average_1min" {
  value = "${datadog_monitor.load_average_1.id}"
}

output "load_average_5min" {
  value = "${datadog_monitor.load_average_1.id}"
}

output "load_average_15min" {
  value = "${datadog_monitor.load_average_15.id}"
}

output "memory_free_bytes" {
  value = "${datadog_monitor.memory_free.id}"
}

output "swap_free_bytes" {
  value = "${datadog_monitor.swap_free.id}"
}

output "network_incoming_bytes" {
  value = "${datadog_monitor.network_incoming.id}"
}

output "network_outgoing_bytes" {
  value = "${datadog_monitor.network_outgoing_bytes.id}"
}

output "network_incoming_packets_per_sec" {
  value = "${datadog_monitor.network_incoming_packets.id}"
}

output "network_outgoing_packets_per_sec" {
  value = "${datadog_monitor.network_outgoing_packets.id}"
}
