terraform {
  required_version = ">= 1.0.0"

  required_providers {
    datadog = {
      source = "datadog/datadog"
      # Must have >= 3.45.0 to have include JavaScript Assertions
      version = ">= 3.49.0"
    }
  }
}
