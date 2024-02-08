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

You can then use the `jsondecode()` function in Terraform to convert the JSON
to a Terraform object, and use that object as the value for the monitor definition.
You can also transform the JSON to HCL other ways, however you prefer. The
relevant point is that this module will accept the monitor definition in this
schema. Any field in the API schema that does not have a counterpart in the
Terraform schema will be ignored.

#### Special Notes

Note that `restricted_roles_map` provides a convenient way to specify the
`restricted_roles` attribute of the monitor. This is a map of monitors to
sets of Datadog role names. If provided, this will override the `restricted_roles`
attribute of the monitor definition. If not provided, the `restricted_roles`
attribute of the monitor definition will be used, but be aware this the attribute
value is a list of unique role identifiers, not role names.

The `alert_tags` input is provided for convenience. It is used to add notification
tags to the monitor message. However, it does not check to see if the tags are
already present. If the tags are already present, they will still be added again.
Thus, if you define a monitor via JSON, and then you use `alert_tags` when
creating it, and then export the JSON representation of the created monitor definition, 
it will not match because of the added tags.


### Legacy schema (deprecated)

Historically, and preserved for backward compatibility, you can configure tests
using the schema used in v1.3.0 and earlier. This schema flattens the monitor
definition, pulling up the `options` attributes to the top level. Note that
not all fields are supported in this schema, and it is only preserved for
backward compatibility. We recommend that you use the API schema going forward.

