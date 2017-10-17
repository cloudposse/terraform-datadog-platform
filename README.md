# terraform-datadog-monitor

A Terraform module which contains a number of common configurations of monitors for Datadog.


## Datadog monitors catalog

- [load_average](https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/load_average)
    - Terraform module to provision Load Average Monitors in Datadog.

## Usage

- [load_average](https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/load_average)

Create monitor for all hosts in Datadog:

```terraform
module "global_monitors" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor//modules/load_average"
  namespace       = "${var.namespace}"
  stage           = "${var.stage}"
  name            = "${var.name}"
  datadog_api_key = "${var.datadog_api_key}"
  datadog_app_key = "${var.datadog_app_key}"
}
```

Create monitor for tagged hosts in Datadog:

```terraform
module "tagged_monitors" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor//modules/load_average"
  namespace       = "${var.namespace}"
  stage           = "${var.stage}"
  name            = "${var.name}"
  datadog_api_key = "${var.datadog_api_key}"
  datadog_app_key = "${var.datadog_app_key}"
  selector        = ["region:us-east-1"]
}
```

## License

Apache 2 Licensed. See LICENSE for full details.
