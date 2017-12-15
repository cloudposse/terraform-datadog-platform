# terraform-datadog-monitor

## Swap Space

Terraform module to configure Swap Space Datadog monitor


## Usage

Create Datadog Swap Space monitor for all hosts:

```hcl
module "datadog_swap_space_global" {
  source             = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/swap"
  namespace          = "cp"
  stage              = "prod"
  name               = "app"
  attributes         = ["global"]
  datadog_api_key    = "xxxxxxxxxxxxxxxxxxxxx"
  datadog_app_key    = "xxxxxxxxxxxxxxxxxxxxx"
  ok_threshold       = "1000000000"
  warning_threshold  = "500000000"
  critical_threshold = "100000000"
}
```

Create Datadog Swap Space monitor for tagged hosts:

```hcl
module "datadog_swap_space_us_east_1" {
  source             = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/swap"
  namespace          = "cp"
  stage              = "prod"
  name               = "app"
  attributes         = ["global"]
  datadog_api_key    = "xxxxxxxxxxxxxxxxxxxxx"
  datadog_app_key    = "xxxxxxxxxxxxxxxxxxxxx"
  ok_threshold       = "1000000000"
  warning_threshold  = "500000000"
  critical_threshold = "100000000"
  selector           = ["region:us-east-1"]
}
```


## Inputs

|  Name                          |  Default                          |  Description                                                                                                                    | Required |
|:-------------------------------|:---------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`                    | ``                                | Namespace (_e.g._ `cp` or `cloudposse`)                                                                                         | Yes      |
| `stage`                        | ``                                | Stage (_e.g._ `prod`, `dev`, `staging`)                                                                                         | Yes      |
| `name`                         | ``                                | Application or solution name (_e.g._ `app`)                                                                                     | Yes      |
| `attributes`                   | `[]`                              | Additional attributes (_e.g._ `global` or `us-eat-1`)                                                                           | No       |
| `tags`                         | `{}`                              | Additional tags (_e.g._ `map("BusinessUnit","XYZ")`                                                                             | No       |
| `delimiter`                    | `-`                               | Delimiter to be used between `name`, `namespace`, `stage`, 'attributes`                                                         | No       |


## Outputs

| Name                        | Description                             |
|:----------------------------|:----------------------------------------|
| `swap_space_id`             | ID of Swap Space monitor                |



## License

[APACHE 2.0](LICENSE) © 2017 [Cloud Posse, LLC](https://cloudposse.com)

See [`LICENSE`](LICENSE) for full details.
