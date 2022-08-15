# Datadog SLO

This module is responsible for creating Datadog [Service Level Objectives](https://docs.datadoghq.com/monitors/service_level_objectives/) and their related monitors and alerts.

The module can create metric-based SLOs (and the corresponding alerts) and monitor-based SLOs (and the corresponding monitors).

## Alerts

Datadog alerts for SLOs are terraformed through the monitor object.

An SLO can have many thresholds set, but a monitor can only have one. In order to get around this, the module creates Datadog monitors for each threshold within an SLO. 

## Usage

Example of metric-based SLO:

```yaml
metric-slo:
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
      timeframe: "7d"
      warning: "99.9"
    - target: "99"
      timeframe: "30d"
      warning: "99.5"
  tags:
    ManagedBy: terraform
    test: true
    api_version: null
```

Example of monitor-based SLO:

```yaml
monitor-slo:
  name: "(SLO) EC2 Availability"
  type: monitor
  description: |
    Number of EC2 failed status checks.
  message: |
    ({stage} {region}) {instance_id} failed a SLO check
  force_delete: true
  validate: true
  thresholds:
    - target: "99.5"
      timeframe: "7d"
      warning: "99.9"
    - target: "99"
      timeframe: "30d"
      warning: "99.5"
  # Either `monitor_ids` or `monitors` should be provided
  # `monitor_ids` is a list of externally created monitors to use for this monitor-based SLO
  # If `monitors` map is provided, the monitors will be created by the module and assigned to the SLO
  monitor_ids: null
  monitors:
    ec2-failed-status-check:
      name: "(EC2) Status Check"
      type: metric alert
      query: |
        avg(last_10m):avg:aws.ec2.status_check_failed{*} by {instance_id} > 0
      message: |
        ({stage} {region}) {instance_id} failed a status check
      escalation_message: ""
      tags:
        ManagedBy: Terraform
      priority: 3
      notify_no_data: false
      notify_audit: true
      require_full_window: true
      enable_logs_sample: false
      force_delete: true
      include_tags: true
      locked: false
      renotify_interval: 60
      timeout_h: 0
      evaluation_delay: 60
      new_host_delay: 300
      new_group_delay: 0
      groupby_simple_monitor: false
      renotify_occurrences: 0
      renotify_statuses: []
      validate: true
      no_data_timeframe: 10
      threshold_windows: {}
      thresholds:
        critical: 0
  tags:
    ManagedBy: terraform
    test: true
    api_version: null
```

## References
 - [Service Level Objectives](https://docs.datadoghq.com/monitors/service_level_objectives/)
 - [Monitor-based SLOs](https://docs.datadoghq.com/monitors/service_level_objectives/monitor/)
 - [Datadog Error Budget](https://docs.datadoghq.com/monitors/service_level_objectives/error_budget/)
 - [Monitor-based SLO example](https://github.com/DataDog/terraform-provider-datadog/issues/667)
