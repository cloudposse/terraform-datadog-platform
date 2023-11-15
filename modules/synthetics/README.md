## synthetics

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
