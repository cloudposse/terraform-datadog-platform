## monitors

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

