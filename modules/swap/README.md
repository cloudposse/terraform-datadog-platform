# terraform-datadog-monitor
## Swap Space

Terraform module to configure Swap Space Datadog monitor


## Usage

Create Datadog Swap Space monitor for all hosts:

```hcl
module "datadog_swap_space_global" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/swap"
  namespace       = "cp"
  stage           = "prod"
  name            = "app"
  datadog_api_key = "xxxxxxxxxxxxxxxxxxxxx"
  datadog_app_key = "yyyyyyyyyyyyyyyyyyyyy"
}
```

Create Datadog Swap Space monitor for tagged hosts:

```hcl
module "datadog_swap_space_us_east_1" {
  source          = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/swap"
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
