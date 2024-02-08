terraform {
  required_version = ">= 1.0.0"

  required_providers {
    datadog = {
      source = "datadog/datadog"
      # >= 3.36.0 is required, so that bugfix for "start" is included.
      # See https://github.com/DataDog/terraform-provider-datadog/issues/2255
      version = ">= 3.36.0"
    }
  }
}
