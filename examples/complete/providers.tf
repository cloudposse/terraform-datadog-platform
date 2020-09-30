# For the example, we use ENV variables `DD_API_KEY ` and `DD_APP_KEY` to specify `api_key` and `app_key` to the provider
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs#argument-reference
provider "datadog" {
}

provider "aws" {
  region = var.region
}
