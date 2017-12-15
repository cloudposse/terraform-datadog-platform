# terraform-datadog-monitor

## CPU Usage

Terraform module to configure CPU Usage Datadog monitor


## Usage

Create Datadog CPU Usage monitor for all hosts:

```hcl
module "datadog_cpu_usage_global" {
  source             = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/cpu"
  namespace          = "cp"
  stage              = "prod"
  name               = "app"
  attributes         = ["global"]
  datadog_api_key    = "xxxxxxxxxxxxxxxxxxxxx"
  datadog_app_key    = "yyyyyyyyyyyyyyyyyyyyy"
  ok_threshold       = "20"
  warning_threshold  = "50"
  critical_threshold = "80"
}
```

Create Datadog CPU Usage monitor for tagged hosts:

```hcl
module "datadog_cpu_usage_us_east_1" {
  source             = "https://github.com/cloudposse/terraform-datadog-monitor/tree/master/modules/cpu"
  namespace          = "cp"
  stage              = "prod"
  name               = "app"
  attributes         = ["global"]
  datadog_api_key    = "xxxxxxxxxxxxxxxxxxxxx"
  datadog_app_key    = "yyyyyyyyyyyyyyyyyyyyy"
  ok_threshold       = "20"
  warning_threshold  = "50"
  critical_threshold = "80"
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
| `cpu_average_percent_id`    | ID of CPU Usage monitor                 |
| `cpu_iowait_percent_id`     | ID of CPU IOWait monitor                |



## License

[APACHE 2.0](LICENSE) © 2017 [Cloud Posse, LLC](https://cloudposse.com)

See [`LICENSE`](LICENSE) for full details.
