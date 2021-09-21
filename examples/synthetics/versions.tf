terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 1.3"
    }
    datadog = {
      source  = "datadog/datadog"
      version = ">= 3.0.0"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 0.14.0"
    }
  }
}
