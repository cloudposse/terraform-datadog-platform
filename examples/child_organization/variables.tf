# https://docs.datadoghq.com/account_management/org_settings/#overview

variable "region" {
  type        = string
  description = "AWS region"
}

variable "organization_name" {
  type        = string
  description = "Datadog organization name"
}
