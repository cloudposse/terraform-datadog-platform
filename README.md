# terraform-datadog-monitor

A Terraform module which contains a number of common configurations of monitors for Datadog.


## Datadog monitors catalog

- [system](https://github.com/cloudposse/terraform-datadog-monitor/tree/master/system)
    - Terraform module to provision Standard System Monitors (cpu, memory, swap, io, etc) in Datadog.

## Usage

- [system](https://github.com/cloudposse/terraform-datadog-monitor/tree/master/system)

```terraform
module "monitors" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor//system"
  namespace       = "${var.namespace}"
  stage           = "${var.stage}"
  name            = "${var.name}"
  datadog_api_key = "${var.datadog_api_key}"
  datadog_app_key = "${var.datadog_app_key}"
  instance_id     = "${var.instance_id}"
}
```

## License

Apache 2 Licensed. See LICENSE for full details.
