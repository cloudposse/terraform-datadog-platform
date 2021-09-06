# https://docs.datadoghq.com/account_management/rbac/?tab=datadogapplication
variable "datadog_roles" {
  type = map(object({
    name        = string
    permissions = set(string)
  }))
  description = "Map of Datadog role configurations. See catalog for examples"
}
