terraform {
  required_version = ">= 1.0.0"

  required_providers {
    datadog = {
      source = "datadog/datadog"

      version = ">= 4.0.0"
    }
  }
}
