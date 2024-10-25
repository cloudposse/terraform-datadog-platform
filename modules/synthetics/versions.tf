terraform {
  required_version = ">= 1.0.0"

  required_providers {
    datadog = {
      source = "datadog/datadog"
      # Must have >= 3.43.1 to have fix for https://github.com/DataDog/terraform-provider-datadog/issues/2531
      version = ">= 3.43.1"
    }
  }
}
