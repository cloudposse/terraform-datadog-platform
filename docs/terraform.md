<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | >= 2.0 |
| datadog | >= 2.13 |
| local | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| datadog | >= 2.13 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| alert\_tags | List of alert tags to add to all alert messages, e.g. `["@opsgenie"]` or `["@devops", "@opsgenie"]` | `list(string)` | `null` | no |
| alert\_tags\_separator | Separator for the alert tags. All strings from the `alert_tags` variable will be joined into one string using the separator and then added to the alert message | `string` | `"\n"` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| datadog\_monitors | List of Datadog monitor configurations. See catalog for examples | <pre>map(object({<br>    name                = string<br>    type                = string<br>    message             = string<br>    escalation_message  = string<br>    query               = string<br>    tags                = list(string)<br>    notify_no_data      = bool<br>    new_host_delay      = number<br>    evaluation_delay    = number<br>    no_data_timeframe   = number<br>    renotify_interval   = number<br>    notify_audit        = bool<br>    timeout_h           = number<br>    enable_logs_sample  = bool<br>    include_tags        = bool<br>    require_full_window = bool<br>    locked              = bool<br>    force_delete        = bool<br>    threshold_windows   = map(any)<br>    thresholds          = map(any)<br>  }))</pre> | n/a | yes |
| datadog\_synthetics | List of DataDog synthetic test configurations. See catalog for examples | <pre>map(object({<br>    name      = string<br>    message   = string<br>    type      = string<br>    subtype   = string<br>    status    = string<br>    locations = list(string)<br>    tags      = list(string)<br>    assertions = list(object({<br>      type     = string<br>      operator = string<br>      target   = any<br>    }))<br>  }))</pre> | `{}` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| datadog\_monitor\_names | Names of the created Datadog monitors |
| datadog\_synthetics\_test\_names | Names of the created Datadog Synthetic tests |

<!-- markdownlint-restore -->
