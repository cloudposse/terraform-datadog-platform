<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | >= 2.13 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | >= 2.13 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.21.0 |  |

## Resources

| Name | Type |
|------|------|
| [datadog_monitor.default](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_synthetics_test.default](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/synthetics_test) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_alert_tags"></a> [alert\_tags](#input\_alert\_tags) | List of alert tags to add to all alert messages, e.g. `["@opsgenie"]` or `["@devops", "@opsgenie"]` | `list(string)` | `null` | no |
| <a name="input_alert_tags_separator"></a> [alert\_tags\_separator](#input\_alert\_tags\_separator) | Separator for the alert tags. All strings from the `alert_tags` variable will be joined into one string using the separator and then added to the alert message | `string` | `"\n"` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_datadog_monitors"></a> [datadog\_monitors](#input\_datadog\_monitors) | List of Datadog monitor configurations. See catalog for examples | <pre>map(object({<br>    name                = string<br>    type                = string<br>    message             = string<br>    escalation_message  = string<br>    query               = string<br>    tags                = list(string)<br>    notify_no_data      = bool<br>    new_host_delay      = number<br>    evaluation_delay    = number<br>    no_data_timeframe   = number<br>    renotify_interval   = number<br>    notify_audit        = bool<br>    timeout_h           = number<br>    enable_logs_sample  = bool<br>    include_tags        = bool<br>    require_full_window = bool<br>    locked              = bool<br>    force_delete        = bool<br>    threshold_windows   = map(any)<br>    thresholds          = map(any)<br>  }))</pre> | n/a | yes |
| <a name="input_datadog_synthetics"></a> [datadog\_synthetics](#input\_datadog\_synthetics) | List of Datadog synthetic test configurations. See catalog for examples | <pre>map(object({<br>    name            = string<br>    message         = string<br>    type            = string<br>    subtype         = string<br>    status          = string<br>    locations       = list(string)<br>    tags            = list(string)<br>    request         = map(string)<br>    request_headers = map(string)<br>    request_query   = map(string)<br>    options         = map(string)<br>    assertions      = list(map(any))<br>  }))</pre> | n/a | yes |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_datadog_monitor_ids"></a> [datadog\_monitor\_ids](#output\_datadog\_monitor\_ids) | IDs of the created Datadog monitors |
| <a name="output_datadog_monitor_names"></a> [datadog\_monitor\_names](#output\_datadog\_monitor\_names) | Names of the created Datadog monitors |
| <a name="output_datadog_monitors"></a> [datadog\_monitors](#output\_datadog\_monitors) | A list of the actual monitor objects. |
| <a name="output_datadog_synthetic_tests"></a> [datadog\_synthetic\_tests](#output\_datadog\_synthetic\_tests) | The synthetic tests created in DataDog |
| <a name="output_datadog_synthetics_test_names"></a> [datadog\_synthetics\_test\_names](#output\_datadog\_synthetics\_test\_names) | Names of the created Datadog Synthetic tests |
<!-- markdownlint-restore -->
