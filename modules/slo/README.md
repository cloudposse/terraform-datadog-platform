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


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | >= 3.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_datadog_monitors"></a> [datadog\_monitors](#module\_datadog\_monitors) | ../monitors | n/a |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [datadog_monitor.metric_slo_alert](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_service_level_objective.metric_slo](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/service_level_objective) | resource |
| [datadog_service_level_objective.monitor_slo](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/service_level_objective) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br/>This is for some rare cases where resources want additional configuration of tags<br/>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_alert_tags"></a> [alert\_tags](#input\_alert\_tags) | List of alert tags to add to all alert messages, e.g. `["@opsgenie"]` or `["@devops", "@opsgenie"]` | `list(string)` | `null` | no |
| <a name="input_alert_tags_separator"></a> [alert\_tags\_separator](#input\_alert\_tags\_separator) | Separator for the alert tags. All strings from the `alert_tags` variable will be joined into one string using the separator and then added to the alert message | `string` | `"\n"` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_datadog_slos"></a> [datadog\_slos](#input\_datadog\_slos) | Map of Datadog SLO configurations | `any` | n/a | yes |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>(Type is `any` so the map values can later be enhanced to provide additional options.)<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` for keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>**Notes:**<br/>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br/>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br/>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br/>  "default"<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_datadog_metric_slo_alerts"></a> [datadog\_metric\_slo\_alerts](#output\_datadog\_metric\_slo\_alerts) | Map of created metric-based SLO alerts |
| <a name="output_datadog_metric_slos"></a> [datadog\_metric\_slos](#output\_datadog\_metric\_slos) | Map of created metric-based SLOs |
| <a name="output_datadog_monitor_slo_monitors"></a> [datadog\_monitor\_slo\_monitors](#output\_datadog\_monitor\_slo\_monitors) | Created monitors for the monitor-based SLOs |
| <a name="output_datadog_monitor_slos"></a> [datadog\_monitor\_slos](#output\_datadog\_monitor\_slos) | Map of created monitor-based SLOs |
<!-- markdownlint-restore -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

