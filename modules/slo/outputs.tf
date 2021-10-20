#output "datadog_slo_names" {
#  value       =  join(datadog_service_level_objective.metric_slo[*],
#                      datadog_service_level_objective.monitor_slo[*])
#  description = "Names of the created Datadog monitors"
#}
output "datadog_metric_slo_names" {
  value       = datadog_service_level_objective.metric_slo[*]
  description = "Names of the created Datadog monitors"
}
output "datadog_monitor_slo_names" {
  value       = datadog_service_level_objective.monitor_slo[*]
  description = "Names of the created Datadog monitors"
}

#output "datadog_monitor_ids" {
#  value       =  join(datadog_service_level_objective.metric_slo[*],
#                      datadog_service_level_objective.monitor_slo[*])
#  description = "IDs of the created Datadog Slos"
#}
#
#output "datadog_monitors" {
#  value       = datadog_monitor.default
#  description = "Datadog monitor outputs"
#}
