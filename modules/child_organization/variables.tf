# https://docs.datadoghq.com/account_management/org_settings/#overview

variable "organization_name" {
  type        = string
  description = "Datadog organization name"
}

variable "saml_enabled" {
  type        = bool
  default     = false
  description = "Whether or not SAML is enabled for the child organization. Note that Free and Trial organizations cannot enable SAML"
}

variable "saml_autocreate_users_domains" {
  type        = list(string)
  default     = []
  description = "List of domains where the SAML automated user creation is enabled"
}

variable "saml_autocreate_users_enabled" {
  type        = bool
  default     = false
  description = "Whether or not the automated user creation based on SAML domain is enabled"
}

variable "saml_idp_initiated_login_enabled" {
  type        = bool
  default     = true
  description = "Whether or not IdP initiated login is enabled for the Datadog organization"
}

variable "saml_strict_mode_enabled" {
  type        = bool
  default     = false
  description = "Whether or not the SAML strict mode is enabled. If true, all users must log in with SAML"
}

variable "private_widget_share" {
  type        = bool
  default     = false
  description = "Whether or not the organization users can share widgets outside of Datadog"
}

variable "saml_autocreate_access_role" {
  type        = string
  default     = "ro"
  description = "The access role of an autocreated user. Options are `st` (standard user), `adm` (admin user), or `ro` (read-only user). Allowed enum values: `st`, `adm` , `ro`, `ERROR`"
}
