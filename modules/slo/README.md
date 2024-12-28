# Datadog SLO

This module is responsible for creating Datadog [Service Level Objectives](https://docs.datadoghq.com/monitors/service_level_objectives/) and their related monitors and alerts.

The module can create metric-based SLOs (and the corresponding alerts), monitor-based SLOs (and the corresponding monitors) and time-slice-based SLOs (and the corresponding alerts).

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

Example of time-slice-based SLO:

```yaml
time_slice-slo:
  name: "(SLO) Test API p95 latency Checks"
  type: time_slice
  description: |
    Test API p95 latency should be less than 1 second.
  sli_specification:
    time_slice:
      query:
        formula: "query1 + query2"
        queries:
          - data_source: "metrics"
            name: "query1"
            query: "p95:trace.express.request{env:production,resource_name:get_/api/test,service:my-service}"
          - data_source: "metrics"
            name: "query2"
            query: "p95:trace.express.request{env:production,resource_name:get_/api/test,service:my-service}"
      comparator: "<="
      threshold: 1
      query_interval_seconds: 300
  thresholds:
    - target: 99.0
      timeframe: "30d"
      warning: 99.5

  error_budget_alert:
    enabled: true
    threshold: 80
    timeframe: "30d"
    priority: 2
    message: "Alert on 80% of error budget consumed"

  burn_rate_alert:
    enabled: true
    threshold: 3
    timeframe: "30d"
    long_window: "24h"
    short_window: "120m"
    priority: 2
    message: "Burn rate is high enough to deplete error budget in one day"

  tags:
    service: my-service
    env: production
```

## References
 - [Service Level Objectives](https://docs.datadoghq.com/monitors/service_level_objectives/)
 - [Monitor-based SLOs](https://docs.datadoghq.com/monitors/service_level_objectives/monitor/)
 - [Time-slice-based SLOs](https://docs.datadoghq.com/monitors/service_level_objectives/time_slice/)
 - [Datadog Error Budget](https://docs.datadoghq.com/monitors/service_level_objectives/error_budget/)
 - [Monitor-based SLO example](https://github.com/DataDog/terraform-provider-datadog/issues/667)
