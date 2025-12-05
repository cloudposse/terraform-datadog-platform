## Datadog monitors

This module creates Datadog [monitors](https://docs.datadoghq.com/api/latest/monitors/).
It accepts all the configuration parameters supported by the Datadog Terraform
resource.

## Usage

The `datadog_monitors` input takes a map of test definitions. You must supply
the keys for the map, but the values can follow either of two schemas described 
below.

There are some optional additions to the monitor definition that are not
part of the Datadog API schema. These are:
- `force_delete` (boolean): If true, when deleting the monitor, the monitor 
  will be deleted even if it is referenced by other resources.
- `validate` (boolean): If false, the monitor will not be validated during
  the Terraform plan phase.
- `enabled` (boolean): If false, the monitor will not be created. This is to 
  allow you to suppress a monitor created through merging configuration snippets.

### Tags

This module provides special handling for tags. The `tags` attribute of a monitor
definition in the Datadog API and the Terraform resource is a list of strings. 
However, the Cloud Posse (as well as AWS) default is to use a map of strings
for tags. This module allows you to provide either a list or a map for the tags.

If you provide a list, it will be used as is. If you provide a map, it will be
converted to a list of strings in the format `key:value` (or `key` if `value` is
`null`). If you provide no tag settings at all, not even an empty list or map,
the module will use the default tags from the [null-label](https://github.com/cloudposse/terraform-null-label/) module.

### API Schema (preferred)

Datadog provides a REST API for managing monitors. We refer to the responses
to the API requests for monitor definitions (`GET https://api.datadoghq.com/api/v1/monitor/{monitor_id}`) 
as the "API Schema" for the tests. This should correspond to the documented 
API "Model" for Monitors plus additional information such as creation date,
but if the documentation and the API response differ, we use the API response
as the source of truth.

You can retrieve Monitor definitions from Datadog via the Datadog Web Console.
Navigate to the monitor you want to retrieve, click the gear icon in the upper
right (representing "settings"), and select "Export". This will display a JSON
representation of the monitor definition. You can then click the "Copy" button
to copy the JSON to the clipboard.

<details><summary>Example of JSON for monitors</summary>

Note that many elements of the monitor definition are optional, and the JSON
representation will only include the elements that are set. This is an example
of a monitor, not a comprehensive list of all possible elements.

```json
{
  "name": "schedule-test",
  "type": "event-v2 alert",
  "query": "events(\"service:datadog-agent\").rollup(\"cardinality\", \"@evt.id\").current(\"1h\") > 2345",
  "message": "No message",
  "tags": [
    "test:examplemonitor",
    "Terratest"
  ],
  "options": {
    "thresholds": {
      "critical": 2345,
      "warning": 987
    },
    "enable_logs_sample": false,
    "notify_audit": false,
    "on_missing_data": "default",
    "include_tags": false,
    "scheduling_options": {
      "custom_schedule": {
        "recurrences": [
          {
            "rrule": "FREQ=DAILY;INTERVAL=1;BYHOUR=17;BYMINUTE=54",
            "timezone": "America/Los_Angeles"
          }
        ]
      },
      "evaluation_window": {
        "hour_starts": 7
      }
    }
  },
  "priority": 5
}
```

</details>

You can find other examples in the [examples/complete/monitors-test/](../../examples/complete/monitors-test) directory.

You can then use the `jsondecode()` function in Terraform to convert the JSON
to a Terraform object, and use that object as the value for the monitor definition.
You can also transform the JSON to HCL other ways, however you prefer. The
relevant point is that this module will accept the monitor definition in this
schema. Any field in the API schema that does not have a counterpart in the
Terraform schema will be ignored.

#### Special Notes

The `alert_tags` input is provided for convenience. It is used to add notification
tags to the monitor message. However, it does not check to see if the tags are
already present. If the tags are already present, they will still be added again.

> [!IMPORTANT]
> 
> If you define a monitor via JSON, and then you use `alert_tags` when creating
> it, and then export the JSON representation of the created monitor definition, 
> it will not match because of the added tags.

Note that `restricted_roles_map` provides a convenient way to specify the
`restricted_roles` attribute of the monitor. This is a map of monitors to
sets of Datadog unique role identifiers. If provided, this will override the
`restricted_roles` attribute of the monitor definition. If not provided, the
`restricted_roles` attribute of the monitor definition will be used, if present.

> [!IMPORTANT]
> 
> ### Legacy schema (deprecated)
> 
> Historically, and preserved for backward compatibility, you can configure tests
> using the schema used in v1.3.0 and earlier. This schema flattens the monitor
> definition, pulling up the `options` attributes to the top level. 
> 
> Note that not all fields are supported in this schema, and it is only preserved for
> backward compatibility. We recommend that you use the API schema going forward.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | >= 3.36.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | >= 3.36.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [datadog_monitor.default](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br/>This is for some rare cases where resources want additional configuration of tags<br/>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_alert_tags"></a> [alert\_tags](#input\_alert\_tags) | List of alert tags to add to all alert messages, e.g. `["@opsgenie"]` or `["@devops", "@opsgenie"]` | `list(string)` | `null` | no |
| <a name="input_alert_tags_separator"></a> [alert\_tags\_separator](#input\_alert\_tags\_separator) | Separator for the alert tags. All strings from the `alert_tags` variable will be joined into one string using the separator and then added to the alert message | `string` | `"\n"` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_datadog_monitors"></a> [datadog\_monitors](#input\_datadog\_monitors) | Map of Datadog monitor configurations. See the README for details on the expected structure.<br/>Keys will be used as monitor names if not provided in the `name` attribute.<br/>Attributes match [Datadog "Create a monitor" API](https://docs.datadoghq.com/api/v1/monitors/#create-a-monitor).<br/>For backward compatibility, attributes under `options` in the API schema that were<br/>previously allowed at the top level remain available at the top level if no `options` are provided.<br/>Because `new_host_delay` is deprecated, it is ignored unless set to zero. | `any` | n/a | yes |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | If true, monitors without `tags` in their definitions will have tags<br/>from `null-label` added to them. Note that even an empty `list` or `map` of tags in<br/>the monitor definition will keep the default tags from being added. | `bool` | `true` | no |
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
| <a name="input_restricted_roles_map"></a> [restricted\_roles\_map](#input\_restricted\_roles\_map) | Map of `datadog_monitors` map keys to sets of Datadog unique role IDs<br/>to restrict access to each monitor. If provided, it will override<br/>the `restricted_roles` attribute in the monitor definition. | `map(set(string))` | `{}` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_datadog_monitor_ids"></a> [datadog\_monitor\_ids](#output\_datadog\_monitor\_ids) | IDs of the created Datadog monitors |
| <a name="output_datadog_monitor_names"></a> [datadog\_monitor\_names](#output\_datadog\_monitor\_names) | Names of the created Datadog monitors |
| <a name="output_datadog_monitors"></a> [datadog\_monitors](#output\_datadog\_monitors) | Datadog monitor outputs |
<!-- markdownlint-restore -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

