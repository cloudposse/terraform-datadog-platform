# Datadog SLO

This module of the datadog platform is responsible for creating SLOs and their related alerts.

## Alerts
Datadog Alerts for SLOs are terraformed through the monitor object.

This creates a problem in that an SLO can have many thresholds set, but a monitor can only have one. In order to get around this the local variable `datadog_slo_metric_monitors` Creates Objects for each threshold within an SLO. 

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
    - managedby:terraform

```

Is Converted to 
```terraform
   datadog_slo_metric_monitors = {
       synthetics-slo_threshold0 = {
           slo       = {
               description  = <<-EOT
                    Number of Successful Synthetic Checks.
                EOT
               force_delete = true
               groups       = []
               message      = <<-EOT
                    ({stage} {region}) {instance_id} failed a SLO check
                EOT
               monitor_ids  = []
               name         = "(SLO) Synthetic Checks"
               query        = {
                   "denominator" = "sum:synthetics.test_runs{*}.as_count()"
                   "numerator"   = "sum:synthetics.test_runs{status:success}.as_count()"
                }
               tags         = [
                   "managedby:terraform",
                ]
               thresholds   = [
                   {
                       target          = "99.5"
                       target_display  = "99.50"
                       timeframe       = "7d"
                       warning         = "99.9"
                       warning_display = "99.90"
                    },
                   {
                       target          = "99"
                       target_display  = "99.00"
                       timeframe       = "30d"
                       warning         = "99.5"
                       warning_display = "99.50"
                    },
                ]
               type         = "metric"
               validate     = true
            }
           slo_name  = "synthetics-slo_threshold0"
           threshold = {
               target          = "99.5"
               target_display  = "99.50"
               timeframe       = "7d"
               warning         = "99.9"
               warning_display = "99.90"
            }
        }
       synthetics-slo_threshold1 = {
           slo       = {
               description  = <<-EOT
                    Number of Successful Synthetic Checks.
                EOT
               force_delete = true
               groups       = []
               message      = <<-EOT
                    ({stage} {region}) {instance_id} failed a SLO check
                EOT
               monitor_ids  = []
               name         = "(SLO) Synthetic Checks"
               query        = {
                   "denominator" = "sum:synthetics.test_runs{*}.as_count()"
                   "numerator"   = "sum:synthetics.test_runs{status:success}.as_count()"
                }
               tags         = [
                   "managedby:terraform",
                ]
               thresholds   = [
                   {
                       target          = "99.5"
                       target_display  = "99.50"
                       timeframe       = "7d"
                       warning         = "99.9"
                       warning_display = "99.90"
                    },
                   {
                       target          = "99"
                       target_display  = "99.00"
                       timeframe       = "30d"
                       warning         = "99.5"
                       warning_display = "99.50"
                    },
                ]
               type         = "metric"
               validate     = true
            }
           slo_name  = "synthetics-slo_threshold1"
           threshold = {
               target          = "99"
               target_display  = "99.00"
               timeframe       = "30d"
               warning         = "99.5"
               warning_display = "99.50"
            }
        }
    }
```

This allows a monitor to be created for each threshold.


## References
 - [Datadog Error Budget](https://docs.datadoghq.com/monitors/service_level_objectives/error_budget/)
