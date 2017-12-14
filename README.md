# terraform-datadog-monitor

A Terraform module repository which contains a number of common configurations ("submodules") of Datadog monitors.

## Datadog Monitors Catalog

- [load_average](https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/load_average) - Terraform module to provision Load Average Monitors in Datadog

## Usage

- [load_average](https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/load_average)

Create Load Average monitor for all hosts in Datadog:

```hcl
module "datadog_load_average_global" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/load_average"
  namespace       = "cp"
  stage           = "prod"
  name            = "app"
  datadog_api_key = "xxxxxxxxxxxxxxxxxxxxx"
  datadog_app_key = "yyyyyyyyyyyyyyyyyyyyy"
}
```

Create Load Average monitor for tagged hosts in Datadog:

```hcl
module "datadog_load_average_us_east_1" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/load_average"
  namespace       = "cp"
  stage           = "prod"
  name            = "app"
  datadog_api_key = "xxxxxxxxxxxxxxxxxxxxx"
  datadog_app_key = "yyyyyyyyyyyyyyyyyyyyy"
  selector        = ["region:us-east-1"]
}
```



## License

[APACHE 2.0](LICENSE) © 2017 [Cloud Posse, LLC](https://cloudposse.com)

See [`LICENSE`](LICENSE) for full details.
