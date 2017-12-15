# terraform-datadog-monitor
## Memory Usage

Terraform module to configure Memory Usage Datadog monitor


## Usage

Create Datadog Memory Usage monitor for all hosts:

```hcl
module "datadog_memory_usage_global" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/memory"
  namespace       = "cp"
  stage           = "prod"
  name            = "app"
  datadog_api_key = "xxxxxxxxxxxxxxxxxxxxx"
  datadog_app_key = "yyyyyyyyyyyyyyyyyyyyy"
}
```

Create Datadog Memory Usage monitor for tagged hosts:

```hcl
module "datadog_memory_usage_us_east_1" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/memory"
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
