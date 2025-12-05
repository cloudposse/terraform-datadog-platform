## Datadig synthetics

This module creates Datadog [synthetic tests](https://docs.datadoghq.com/api/latest/synthetics/).
It accepts all the configuration parameters supported by the Datadog Terraform
resource except `BasicAuth` authentication wherever it occurs.

## Usage

The `datadog_synthetics` input takes a map of test definitions. You must supply
the keys for the map, but the values can follow either of two schemas described 
below.

### API Schema

Datadog provides a REST API for managing synthetic tests. We refer to the responses
to the API requests for test definitions as the "API Schema" for the tests. 
(Note that some items in the response are read-only, and are ignored if included 
in the definition of a test.) There are errors and omissions in the documentation
of the API output, and where we have found API results that differ from the
documentation, we have used the API results as the source of truth.

You can retrieve test definitions from the Datadog API in 3 ways:

1. You can [retrieve an individual API test](https://docs.datadoghq.com/api/latest/synthetics/#get-an-api-test)
2. You can [retrieve an individual browser test](https://docs.datadoghq.com/api/latest/synthetics/#get-a-browser-test)
3. You can [retrieve a list of all tests](https://docs.datadoghq.com/api/latest/synthetics/#get-the-list-of-all-synthetic-tests)

NOTE: As of this writing (2023-10-20), the list of all tests fails to include the steps in a multistep browser test.
You must use the individual browser test API to retrieve the test definition including the steps.
This is a known issue with Datadog, and hopefully will be fixed soon, but verify that it is fixed before
relying on the list of all tests if you are using multistep browser tests.

The `datadog_synthetics` input takes a map of test definitions. You must supply
the keys for the map, but the values can simply be the output of 
applying Terraform's `jsondecode()` to the output of the API. In the case
of the list of all tests, you must iterate over the list and supply
a key for each test. We recommend that you use the test's `name` as the key.

For any test, you can optionally add `enabled = false` to disable/delete the test.

NOTE: Since this module is implemented in Terraform, any field in the API
schema that does not have a counterpart in the Terraform schema will be ignored.
As of this writing (Datadog Terraform provider version 3.30.0), that includes
the `metatdata` field in the steps of a multistep API test.

See https://github.com/DataDog/terraform-provider-datadog/issues/2155


### Terraform schema

Historically, and preserved for backward compatibility, you can configure tests
using the `datadog_synthetics` input, which takes an object that is a map of
synthetic tests, each test matching the schema of the `datadog_sythetics_test` 
[Terraform resource](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/synthetics_test). See examples with suffix `-terraform.yaml` in 
`examples/synthetics/terraform-schema/catalog`.

One distinction of this schema is that there is no `config` member. Instead,
elements of `config`, such as `assertions`, are pulled up to the top level
and rendered in the singular, e.g. `assertion`. Another change is that `options` is 
renamed `options_list`. When in doubt, refer to the Terraform code to see how
the input is mapped to the Terraform resource.

Note that the Terraform resource does not support the details of the `element`
field for the steps of a multistep browser test. This module allows you to use an object
following the API schema, or you can use a string that is the JSON encoding
of the object. However, if you use the JSON string encoding, and you are 
using a "user locator", you must supply the `element_user_locator` attribute
even though it is already included in the JSON encoding, or else the
Terraform provider will show perpetual drift. 

As with the API schema, you can optionally add `enabled = false` to disable/delete the test.

#### Unsupported inputs

Any of the "BasicAuth" inputs are not supported due to their complexity and 
rare usage. Usually you can use the `headers` input instead. BasicAuth support
could be added if there is a need.

### Locations

The `locations` input takes a list of locations used to run the test. It
defaults to the special value "all" which is used to indicate all _public_
locations. Any locations included in the `locations` list will be _added_ to the 
list of locations specified in the individual test; they will not replace the
list of locations specified in the test.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | >= 3.43.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | >= 3.43.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [datadog_synthetics_test.default](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/synthetics_test) | resource |
| [datadog_synthetics_locations.public_locations](https://registry.terraform.io/providers/datadog/datadog/latest/docs/data-sources/synthetics_locations) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br/>This is for some rare cases where resources want additional configuration of tags<br/>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_alert_tags"></a> [alert\_tags](#input\_alert\_tags) | List of alert tags to add to all alert messages, e.g. `["@opsgenie"]` or `["@devops", "@opsgenie"]` | `list(string)` | `[]` | no |
| <a name="input_alert_tags_separator"></a> [alert\_tags\_separator](#input\_alert\_tags\_separator) | Separator for the alert tags. All strings from the `alert_tags` variable will be joined into one string using the separator and then added to the alert message | `string` | `"\n"` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_datadog_synthetics"></a> [datadog\_synthetics](#input\_datadog\_synthetics) | Map of Datadog synthetic test configurations using Terraform or API schema. See README for details. | `any` | n/a | yes |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | If true, all tests will have tags from `null-label` added to them | `bool` | `true` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>(Type is `any` so the map values can later be enhanced to provide additional options.)<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` for keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>**Notes:**<br/>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br/>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br/>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br/>  "default"<br/>]</pre> | no |
| <a name="input_locations"></a> [locations](#input\_locations) | Array of locations used to run synthetic tests, or `"all"` to use all public locations.<br/>These locations will be added to any locations specified in the `locations` attribute of a test. | `list(string)` | <pre>[<br/>  "all"<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_datadog_synthetic_tests"></a> [datadog\_synthetic\_tests](#output\_datadog\_synthetic\_tests) | The synthetic tests created in DataDog |
| <a name="output_datadog_synthetics_test_ids"></a> [datadog\_synthetics\_test\_ids](#output\_datadog\_synthetics\_test\_ids) | IDs of the created Datadog synthetic tests |
| <a name="output_datadog_synthetics_test_monitor_ids"></a> [datadog\_synthetics\_test\_monitor\_ids](#output\_datadog\_synthetics\_test\_monitor\_ids) | IDs of the monitors associated with the Datadog synthetics tests |
| <a name="output_datadog_synthetics_test_names"></a> [datadog\_synthetics\_test\_names](#output\_datadog\_synthetics\_test\_names) | Names of the created Datadog Synthetic tests |
<!-- markdownlint-restore -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

