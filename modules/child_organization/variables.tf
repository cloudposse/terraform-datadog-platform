# https://docs.datadoghq.com/account_management/org_settings/#overview
variable "saml_enabled" {
  type        = bool
  default     = true
  description = "Whether SAML is enabled for the child organization"
}

variable "saml_autocreate_users_domains" {
  type        = list(string)
  default     = []
  description = "List of domains where the SAML automated user creation is enabled."
}

variable "saml_idp_initiated_login_enabled" {
  type        = bool
  default     = true
  description = "Whether SAML is enabled for the child organization"
}

variable "saml_strict_mode_enabled" {
  type        = bool
  default     = true
  description = "Whether to enforce SAML login only for all users"
}

variable "private_widget_share" {
  type        = bool
  default     = false
  description = "Whether or not organization users can share widgets outside of datadog"
}

variable "saml_autocreate_access_role" {
  type        = string
  default     = "ro"
  description = "The access role of an autocreated user. Options are `st` (standard user), `adm` (admin user), or `ro` (read-only user). Allowed enum values: `st`, `adm` , `ro`, `ERROR`"
}