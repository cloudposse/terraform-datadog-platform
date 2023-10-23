# For the example, we use ENV variables `DD_API_KEY` and `DD_APP_KEY` in place of the `api_key` and `app_key` parameters to the provider
# https://registry.terraform.io/providers/DataDog/datadog/latest/docs#argument-reference
provider "datadog" {
  validate = false
}

