# Datadog SLO

This module is responsible for creating Datadog [Service Level Objectives](https://docs.datadoghq.com/monitors/service_level_objectives/) and their related alerts.

## Alerts
Datadog Alerts for SLOs are terraformed through the monitor object.

An SLO can have many thresholds set, but a monitor can only have one. In order to get around this, the module creates Datadog monitors for each threshold within an SLO. 

For example 

```yaml
synthetics-slo:
  name: "(SLO) Synthetic Checks"
  type: metric
  query:
    numerator: sum:synthetics.test_runs{status:success}.as_count()
    denominator: sum:synthetics.test_runs{*}.as_count()
  description: |
    Number of Successful Synthetic Checks.
  message: |
    ({stage} {region}) {instance_id} failed a SLO check
  force_delete: true
  validate: true
  thresholds:
  - target: "99.5"
    target_display: "99.50"
    timeframe: "7d"
    warning: "99.9"
    warning_display: "99.90"
  - target: "99"
    target_display: "99.00"
    timeframe: "30d"
    warning: "99.5"
    warning_display: "99.50"
  groups: []
  monitor_ids: []
  tags:
    managedby: terraform

```

## References
 - [Service Level Objectives](https://docs.datadoghq.com/monitors/service_level_objectives/)
 - [Monitor-based SLOs](https://docs.datadoghq.com/monitors/service_level_objectives/monitor/)
 - [Datadog Error Budget](https://docs.datadoghq.com/monitors/service_level_objectives/error_budget/)
