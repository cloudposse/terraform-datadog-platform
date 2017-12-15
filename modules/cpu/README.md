# terraform-datadog-monitor
## CPU Usage

Terraform module to configure CPU Usage Datadog monitor


## Usage

Create Datadog CPU Usage monitor for all hosts:

```hcl
module "datadog_cpu_usage_global" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/cpu"
  namespace       = "cp"
  stage           = "prod"
  name            = "app"
  datadog_api_key = "xxxxxxxxxxxxxxxxxxxxx"
  datadog_app_key = "yyyyyyyyyyyyyyyyyyyyy"
}
```

Create Datadog CPU Usage monitor for tagged hosts:

```hcl
module "datadog_cpu_usage_us_east_1" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/cpu"
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
