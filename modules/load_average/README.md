# terraform-datadog-monitor

## Load Average

Terraform module to configure Load Average Datadog monitor


## Usage

Create Datadog Load Average monitor for all hosts:

```hcl
module "datadog_load_average_global" {
  source             = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/load_average"
  namespace          = "cp"
  stage              = "prod"
  name               = "app"
  attributes         = ["global"]
  datadog_api_key    = "xxxxxxxxxxxxxxxxxxxxx"
  datadog_app_key    = "xxxxxxxxxxxxxxxxxxxxx"
  ok_threshold       = "1"
  warning_threshold  = "5"
  critical_threshold = "10"
}
```

Create Datadog Load Average monitor for tagged hosts:

```hcl
module "datadog_load_average_us_east_1" {
  source             = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/load_average"
  namespace          = "cp"
  stage              = "prod"
  name               = "app"
  attributes         = ["global"]
  datadog_api_key    = "xxxxxxxxxxxxxxxxxxxxx"
  datadog_app_key    = "xxxxxxxxxxxxxxxxxxxxx"
  ok_threshold       = "1"
  warning_threshold  = "5"
  critical_threshold = "10"
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
| `load_average_1_id`         | ID of 1m Load Average monitor           |
| `load_average_5_id`         | ID of 5m Load Average monitor           |
| `load_average_15_id`        | ID of 15m Load Average monitor          |



## License

[APACHE 2.0](LICENSE) © 2017 [Cloud Posse, LLC](https://cloudposse.com)

See [`LICENSE`](LICENSE) for full details.
